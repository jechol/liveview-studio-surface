defmodule LiveViewStudioWeb.Components.Volunteer do
  use LiveViewStudioWeb, :surface_component

  prop id, :string, required: true
  prop click, :event, required: true
  prop volunteer, :map, required: true

  def render(assigns) do
    ~F"""
    <div class={"volunteer", out: @volunteer.checked_out} id={@id}>
      <div class="name">
        {@volunteer.name}
      </div>
      <div class="phone">
        {@volunteer.phone}
      </div>
      <div class="status">
        <button :on-click={@click} phx-value-id={@volunteer.id}>
          {#if @volunteer.checked_out}
            Check In
          {#else}
            Check Out
          {/if}
        </button>
      </div>
    </div>
    """
  end
end
