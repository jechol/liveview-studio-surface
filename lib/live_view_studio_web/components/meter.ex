defmodule LiveViewStudioWeb.Components.Meter do
  use LiveViewStudioWeb, :surface_component

  @doc "Name of input tag"
  prop name, :string

  @doc "Numeric value to display"
  prop value, :number, default: 0

  @doc "Unit of value"
  prop unit, :string, required: true

  def render(assigns) do
    ~F"""
    <div class="mt-1 relative rounded-md shadow-sm">
      <input type="number" name={@name} value={@value} class="focus:ring-indigo-300 focus:border-indigo-300 block w-full min-w-0 pl-6 pr-16 text-sm border-slate-300 rounded-md transition duration-150 ease-in-out appearance-none">
      <span class="absolute inset-y-0 right-0 pr-4 flex items-center pointer-events-none text-slate-500 text-sm">{@unit}</span>
    </div>
    """
  end
end
