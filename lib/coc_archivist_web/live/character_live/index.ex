defmodule CocArchivistWeb.CharacterLive.Index do
  use CocArchivistWeb, :live_view
  alias CocArchivist.Characters
  alias CocArchivist.Characters.Character

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :characters, Characters.list_characters())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    character = Characters.get_character!(id)

    return_to =
      if character.scenario_id, do: ~p"/scenarios/#{character.scenario_id}", else: ~p"/characters"

    socket
    |> assign(:page_title, "Edit Character")
    |> assign(:character, character)
    |> assign(:return_to, return_to)
    |> assign(:filter_form, to_form(%{"character_type" => ""}))
  end

  defp apply_action(socket, :new, params) do
    character = %Character{
      scenario_id: params["scenario_id"],
      character_type: "npc"
    }

    return_to =
      if params["scenario_id"] do
        ~p"/scenarios/#{params["scenario_id"]}"
      else
        ~p"/characters"
      end

    socket
    |> assign(:page_title, "New Character")
    |> assign(:character, character)
    |> assign(:return_to, return_to)
    |> assign(:filter_form, to_form(%{"character_type" => ""}))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Characters")
    |> assign(:character, nil)
    |> assign(:return_to, ~p"/characters")
    |> assign(:filter_form, to_form(%{"character_type" => ""}))
  end

  @impl true
  def handle_info({CocArchivistWeb.CharacterLive.FormComponent, {:saved, character}}, socket) do
    {:noreply, stream_insert(socket, :characters, character)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    character = Characters.get_character!(id)
    {:ok, _} = Characters.delete_character(character)

    {:noreply, stream_delete(socket, :characters, character)}
  end

  def handle_event("filter", %{"character_type" => character_type}, socket) do
    characters =
      if character_type == "" do
        Characters.list_characters()
      else
        Characters.list_characters_by_type(character_type)
      end

    {:noreply, stream(socket, :characters, characters, reset: true)}
  end

  def handle_event("filter", _params, socket) do
    {:noreply, socket}
  end
end
