defmodule CocArchivistWeb.CharacterLive.EditableTextComponent do
  use CocArchivistWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="group relative">
      <div class="flex items-center justify-between">
        <div class="flex-1">
          <div
            :if={!@editing}
            class="mt-1 text-gray-100 group-hover:pr-8"
            phx-click="edit"
            phx-target={@myself}
          >
            {@value || "Not set"}
          </div>
        </div>
        <button
          :if={!@editing}
          type="button"
          class="invisible group-hover:visible absolute inset-y-0 right-0 flex items-center pr-2 text-gray-400 hover:text-emerald-400"
          phx-click="edit"
          phx-target={@myself}
        >
          <.icon name="hero-pencil-square" class="h-4 w-4" />
        </button>
      </div>

      <form :if={@editing} class="mt-1" phx-submit="save" phx-target={@myself}>
        <input type="hidden" name="field" value={@field} />
        <div class="relative">
          <div class="relative">
            <input
              type="text"
              name="value"
              value={@value}
              id={"editable-#{@field}"}
              class="block w-full bg-transparent py-0 pl-0 pr-20 text-gray-100 focus:outline-none focus:ring-0 leading-6 [&::-webkit-search-decoration]:appearance-none [&::-webkit-search-cancel-button]:appearance-none [&::-webkit-search-results-button]:appearance-none [&::-webkit-search-results-decoration]:appearance-none"
              style="margin-top: 0; margin-bottom: 0; padding-top: 0; padding-bottom: 0; border: none;"
              phx-mounted={JS.focus() |> JS.dispatch("focus", to: "#editable-#{@field}")}
              phx-target={@myself}
            />
            <div class="absolute bottom-0 left-0 h-[1px] w-full bg-gray-600 group-focus-within:bg-emerald-500">
            </div>
          </div>
          <div class="absolute inset-y-0 right-0 flex items-center gap-1 pr-1">
            <button type="submit" class="text-emerald-400 hover:text-emerald-300">
              <.icon name="hero-check" class="w-5 h-5" />
            </button>
            <button
              type="button"
              class="text-red-400 hover:text-red-300"
              phx-click="cancel"
              phx-target={@myself}
            >
              <.icon name="hero-x-mark" class="h-5 w-5" />
            </button>
          </div>
        </div>
      </form>
    </div>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, editing: false)}
  end

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:editing, false)}
  end

  def handle_event("edit", _, socket) do
    {:noreply, assign(socket, editing: true)}
  end

  def handle_event("save", %{"value" => value}, socket) do
    send(self(), {:update_field, %{field: socket.assigns.field, value: value}})
    {:noreply, assign(socket, editing: false)}
  end

  def handle_event("cancel", _, socket) do
    {:noreply, assign(socket, editing: false)}
  end
end
