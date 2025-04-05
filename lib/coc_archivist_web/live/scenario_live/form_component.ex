defmodule CocArchivistWeb.ScenarioLive.FormComponent do
  use CocArchivistWeb, :live_component

  alias CocArchivist.Scenarios

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage scenario records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="scenario-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        multipart={true}
      >
        <div class="mb-6">
          <label class="block text-sm font-semibold leading-6 text-gray-100 mb-2">Cover Image</label>
          <div class="aspect-w-16 aspect-h-9 mb-4">
            <img
              :if={@scenario.cover}
              src={CocArchivist.Uploaders.ImageUploader.url({@scenario.cover, @scenario}, :original)}
              class="rounded-lg object-cover w-full h-full"
              alt="Current cover"
            />
            <div
              :if={!@scenario.cover}
              class="rounded-lg bg-gray-800 w-full h-full flex items-center justify-center"
            >
              <span class="text-gray-400">No cover image</span>
            </div>
          </div>
          <label class="btn bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 rounded inline-flex items-center gap-2 cursor-pointer">
            Change Cover <.live_file_input upload={@uploads.cover} class="hidden" />
          </label>
        </div>

        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:date]} type="date" label="Date" />
        <.input field={@form[:location]} type="text" label="Location" />
        <.input field={@form[:description]} type="textarea" label="Description" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Scenario</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> allow_upload(:cover,
       accept: ~w(.jpg .jpeg .png .gif),
       max_file_size: 5_000_000
     )}
  end

  @impl true
  def update(%{scenario: scenario} = assigns, socket) do
    changeset = Scenarios.change_scenario(scenario)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"scenario" => scenario_params}, socket) do
    changeset =
      socket.assigns.scenario
      |> Scenarios.change_scenario(scenario_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"scenario" => scenario_params}, socket) do
    [scenario_params_with_cover] =
      consume_uploaded_entries(socket, :cover, fn meta, entry ->
        image_plug_upload =
          %Plug.Upload{
            content_type: entry.client_type,
            filename: entry.client_name,
            path: meta.path
          }

        updated_params =
          Map.put(scenario_params, "cover", image_plug_upload)

        {:postpone, updated_params}
      end)

    save_scenario(socket, socket.assigns.action, scenario_params_with_cover)
  end

  defp save_scenario(socket, :edit, scenario_params) do
    case Scenarios.update_scenario(socket.assigns.scenario, scenario_params) do
      {:ok, scenario} ->
        notify_parent({:saved, scenario})

        {:noreply,
         socket
         |> put_flash(:info, "Scenario updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_scenario(socket, :new, scenario_params) do
    case Scenarios.create_scenario(scenario_params) do
      {:ok, scenario} ->
        notify_parent({:saved, scenario})

        {:noreply,
         socket
         |> put_flash(:info, "Scenario created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
