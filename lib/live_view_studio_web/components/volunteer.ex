defmodule LiveViewStudioWeb.Components.Volunteer do
  use LiveViewStudioWeb, :surface_component

  prop(id, :string, required: true)
  prop(click, :event, required: true)

  prop(volunteer_id, :integer, required: true)
  prop(name, :string, required: true)
  prop(phone, :string, required: true)
  prop(status, :string, required: true)
  prop(checked_out, :string, required: true)

  def render(assigns) do
    ~F"""
    <div class={"volunteer", out: @checked_out} id={@id}>
      <div class="name">
        {@name}
      </div>
      <div class="phone">
        {@phone}
      </div>
      <div class="status">
        <button :on-click={@click} phx-value-id={@volunteer_id}>
          {#if @checked_out}
            Check In
          {#else}
            Check Out
          {/if}
        </button>
      </div>
    </div>
    """
  end

  def to_prop(%LiveViewStudio.Volunteers.Volunteer{} = v) do
    v
    |> Map.from_struct()
    |> Map.take([:name, :phone, :checked_out])
    |> Map.put(:volunteer_id, v.id)
  end
end
