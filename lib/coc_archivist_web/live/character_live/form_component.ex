defmodule CocArchivistWeb.CharacterLive.FormComponent do
  use CocArchivistWeb, :live_component

  alias CocArchivist.Characters

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage character records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="character-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit={@rest[:phx_submit]}
      >
        <.input field={@form[:scenario_id]} type="text" class="hidden" />
        <.input field={@form[:name]} type="text" label="Name" />
        <.input
          field={@form[:character_type]}
          type="select"
          label="Type"
          options={[
            {"Player Character", :player_character},
            {"NPC", :npc},
            {"Monster", :monster}
          ]}
        />
        <.input field={@form[:occupation]} type="text" label="Occupation" />
        <.input field={@form[:age]} type="number" label="Age" />
        <.input field={@form[:sex]} type="text" label="Sex" />
        <.input field={@form[:residence]} type="text" label="Residence" />
        <.input field={@form[:birthplace]} type="text" label="Birthplace" />

        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <.input field={@form[:str]} type="number" label="STR" />
          <.input field={@form[:dex]} type="number" label="DEX" />
          <.input field={@form[:pow]} type="number" label="POW" />
          <.input field={@form[:con]} type="number" label="CON" />
          <.input field={@form[:app]} type="number" label="APP" />
          <.input field={@form[:edu]} type="number" label="EDU" />
          <.input field={@form[:int]} type="number" label="INT" />
          <.input field={@form[:siz]} type="number" label="SIZ" />
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <.input field={@form[:hp]} type="number" label="HP" />
          <.input field={@form[:mp]} type="number" label="MP" />
          <.input field={@form[:san]} type="number" label="SAN" />
          <.input field={@form[:db]} type="text" label="DB" />
        </div>

        <.input field={@form[:skills]} type="textarea" label="Skills" />
        <.input field={@form[:background]} type="textarea" label="Background" />
        <.input field={@form[:personal_description]} type="textarea" label="Personal Description" />
        <.input field={@form[:ideology_beliefs]} type="textarea" label="Ideology & Beliefs" />
        <.input field={@form[:significant_people]} type="textarea" label="Significant People" />
        <.input field={@form[:meaningful_locations]} type="textarea" label="Meaningful Locations" />
        <.input field={@form[:treasured_possessions]} type="textarea" label="Treasured Possessions" />
        <.input field={@form[:traits]} type="textarea" label="Traits" />
        <.input field={@form[:equipment]} type="textarea" label="Equipment" />
        <.input field={@form[:current_sanity]} type="number" label="Current Sanity" />
        <.input field={@form[:sanity_loss]} type="number" label="Sanity Loss" />
        <.input field={@form[:phobias]} type="textarea" label="Phobias" />
        <.input field={@form[:manias]} type="textarea" label="Manias" />
        <.input field={@form[:notes]} type="textarea" label="Notes" />

        <.image_uploader uploads={@uploads} label="Portrait" id={@myself} />

        <:actions>
          <.button phx-disable-with="Saving...">Save Character</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{character: character} = assigns, socket) do
    changeset = Characters.change_character(character)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> allow_upload(:portrait,
       accept: ~w(.png .jpg .jpeg),
       max_file_size: 10_000_000
     )}
  end

  @impl true
  def handle_event("validate", %{"character" => character_params}, socket) do
    changeset =
      socket.assigns.character
      |> Characters.change_character(character_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"character" => character_params}, socket) do
    [character_with_portrait] =
      consume_uploaded_entries(socket, :portrait, fn meta, entry ->
        image_plug_upload =
          %Plug.Upload{
            content_type: entry.client_type,
            filename: entry.client_name,
            path: meta.path
          }

        updated_params =
          Map.put(character_params, "portrait", image_plug_upload)

        {:postpone, updated_params}
      end)

    save_character(socket, socket.assigns.action, character_with_portrait)
  end

  defp save_character(socket, :edit, character_params) do
    case Characters.update_character(socket.assigns.character, character_params) do
      {:ok, character} ->
        notify_parent({:saved, character})

        {:noreply,
         socket
         |> put_flash(:info, "Character updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_character(socket, :new, character_params) do
    case Characters.create_character(character_params) do
      {:ok, character} ->
        notify_parent({:saved, character})

        {:noreply,
         socket
         |> put_flash(:info, "Character created successfully")
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
