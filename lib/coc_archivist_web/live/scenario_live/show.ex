defmodule CocArchivistWeb.ScenarioLive.Show do
  use CocArchivistWeb, :live_view

  alias CocArchivist.Scenarios

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:scenario, Scenarios.get_scenario!(id))}
  end

  defp page_title(:show), do: "Show Scenario"
  defp page_title(:edit), do: "Edit Scenario"
end
