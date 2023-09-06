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
    <style>
      .volunteer {
        @apply mt-2 border border-slate-300 bg-white rounded px-6 py-4 w-full text-lg h-20 grid grid-cols-3 items-center relative;
      }
      .volunteer:hover .delete {
        display: block;
      }
      .volunteer .delete {
        @apply absolute top-1 right-1 hidden cursor-pointer text-sm;
      }
      .volunteer .delete svg,
      .volunteer .delete .hero-trash-solid {
        @apply w-4 h-4 text-slate-400;
      }
      .volunteer .name {
        @apply text-teal-600 font-bold overflow-auto;
        justify-self: start;
      }
      .volunteer .phone {
        @apply flex items-center font-medium text-slate-500;
        justify-self: center;
      }
      .volunteer .status {
        @apply flex items-center font-bold text-base text-teal-600 text-center;
        justify-self: end;
      }
      .volunteer .status button {
        @apply bg-teal-500 text-white w-28 font-medium py-2 px-4 rounded outline-none hover:bg-teal-700;
      }
      .volunteer.out {
        @apply bg-slate-300;
      }
      .volunteer.out button {
        @apply bg-slate-400;
      }
    </style>
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
