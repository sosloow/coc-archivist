defmodule CocArchivistWeb.CharacterComponents do
  use Phoenix.Component

  @doc """
  Renders a 3x3 grid of character characteristics like STR, DEX, etc.
  """
  attr :character, :map, required: true

  def characteristics_grid(assigns) do
    ~H"""
    <div class="grid grid-cols-3 gap-2 max-w-md mx-auto">
      <%= for {label, key} <- [
            {"STR", :str}, {"DEX", :dex}, {"INT", :int},
            {"CON", :con}, {"APP", :app}, {"POW", :pow},
            {"SIZ", :siz}, {"EDU", :edu}
          ] do %>
        <div class="bg-gray-800 shadow rounded p-2">
          <div class="text-sm font-semibold text-gray-300 text-center mb-1">{label}</div>
          <div class="grid grid-cols-2 gap-1">
            <% val = Map.get(@character, key) || 0 %>
            <div class="text-xl font-bold text-emerald-400 text-center row-span-2 flex items-center justify-center">
              {val}
            </div>
            <div class="text-sm text-gray-400 text-center">{div(val, 5)}</div>
            <div class="text-sm text-gray-500 text-center">{div(val, 10)}</div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
