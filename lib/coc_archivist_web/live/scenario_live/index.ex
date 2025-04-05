defmodule CocArchivistWeb.ScenarioLive.Index do
  use CocArchivistWeb, :live_view

  alias CocArchivist.Scenarios
  alias CocArchivist.Scenarios.Scenario

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :scenarios, Scenarios.list_scenarios())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Scenario")
    |> assign(:scenario, Scenarios.get_scenario!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Scenario")
    |> assign(:scenario, %Scenario{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Scenarios")
    |> assign(:scenario, nil)
  end

  @impl true
  def handle_info({CocArchivistWeb.ScenarioLive.FormComponent, {:saved, scenario}}, socket) do
    {:noreply, stream_insert(socket, :scenarios, scenario)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    scenario = Scenarios.get_scenario!(id)
    {:ok, _} = Scenarios.delete_scenario(scenario)

    {:noreply, stream_delete(socket, :scenarios, scenario)}
  end
end
