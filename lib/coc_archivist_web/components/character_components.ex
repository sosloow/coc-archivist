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
            {"SIZ", :siz}, {"EDU", :edu}, {"SAN", :san}
          ] do %>
        <div class="bg-gray-800 shadow rounded p-2 flex justify-between items-start">
          <div class="text-sm font-semibold text-gray-300 mt-1">{label}</div>
          <div class="flex flex-col items-end">
            <% val = Map.get(@character, key) || 0 %>
            <div class="text-lg font-bold text-emerald-400">{val}</div>
            <div class="text-sm text-gray-400">{div(val, 5)}</div>
            <div class="text-sm text-gray-500">{div(val, 10)}</div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
