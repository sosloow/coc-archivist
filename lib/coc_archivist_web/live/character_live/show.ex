defmodule CocArchivistWeb.CharacterLive.Show do
  use CocArchivistWeb, :live_view
  alias CocArchivist.Characters

  import CocArchivistWeb.CharacterComponents

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, editing_fields: [])}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    character = Characters.get_character!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:character, character)
     |> assign(:form, to_form(Characters.change_character(character)))}
  end

  @impl true
  def handle_event("edit_field", %{"field" => field}, socket) do
    {:noreply, update(socket, :editing_fields, &[field | &1])}
  end

  @impl true
  def handle_event("cancel_edit", _params, socket) do
    {:noreply, assign(socket, editing_fields: [])}
  end

  @impl true
  def handle_event("update_field", %{"field" => field, "value" => value}, socket) do
    character = socket.assigns.character

    field_name = String.replace(field, ~r/^character\[|\]$/, "")
    params = %{field_name => value}

    case Characters.update_character(character, params) do
      {:ok, updated_character} ->
        {:noreply,
         socket
         |> assign(:character, updated_character)
         |> assign(:form, to_form(Characters.change_character(updated_character)))
         |> assign(:editing_fields, [])}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("randomize", _params, socket) do
    character = socket.assigns.character
    {:ok, updated_character} = Characters.randomize_characteristics(character)

    {:noreply, assign(socket, :character, updated_character)}
  end

  @impl true
  def handle_info(
        {CocArchivistWeb.CharacterLive.EditableTextComponent, %{id: id, value: value}},
        socket
      ) do
    field = String.to_atom(id)
    character = socket.assigns.character
    params = %{field => value}

    case Characters.update_character(character, params) do
      {:ok, updated_character} ->
        {:noreply,
         socket
         |> assign(:character, updated_character)
         |> assign(:form, to_form(Characters.change_character(updated_character)))}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:update_field, %{field: field, value: value}}, socket) do
    character = socket.assigns.character
    attrs = %{String.to_atom(field) => value}

    case Characters.update_character(character, attrs) do
      {:ok, updated_character} ->
        {:noreply, assign(socket, :character, updated_character)}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  defp page_title(:show), do: "Show Character"
  defp page_title(:edit), do: "Edit Character"

  def format_character_type(:player_character), do: "PLAYER CHARACTER"
  def format_character_type(:npc), do: "NPC"
  def format_character_type(:monster), do: "MONSTER"
  def format_character_type(_), do: "UNKNOWN"
end
