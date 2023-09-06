defmodule LiveViewStudioWeb.LiveComponents.VolunteerForm do
  use LiveViewStudioWeb, :surface_live_component

  alias LiveViewStudio.Volunteers
  alias LiveViewStudio.Volunteers.Volunteer
  alias Phoenix.Component, as: PC
  alias LiveViewStudioWeb.CoreComponents, as: Core
  alias Surface.Components.Form

  prop(count, :integer, required: true)

  data(form, :any)

  def mount(socket) do
    changeset = Volunteers.change_volunteer(%Volunteer{})

    {:ok, assign(socket, :form, PC.to_form(changeset))}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(:count, assigns.count + 1)

    {:ok, socket}
  end

  def render(assigns) do
    ~F"""
    <style>
      div.count {
        @apply py-2 text-lg font-bold text-sky-500;
      }
      :deep(form) {
        @apply px-6 py-4 border-dashed border-2 border-slate-400 mb-8 flex items-baseline justify-around;
      }
      :deep(form div[phx-feedback-for*="volunteer"]) {
        @apply flex-1 mr-4;
      }
      :deep(form input[type="text"]),
      :deep(form input[type="tel"]) {
        @apply w-full appearance-none px-3 py-2 border border-slate-300 rounded-md transition duration-150 ease-in-out text-xl placeholder-slate-400 mt-0;
      }
      :deep(form input[type="text"]:focus),
      :deep(form input[type="tel"]:focus) {
        @apply outline-none border-teal-300 ring ring-teal-300;
      }
      :deep(form button) {
        @apply py-2 px-4 border border-transparent font-medium rounded-md text-white bg-amber-400 transition duration-150 ease-in-out outline-none flex-initial text-lg w-28 hover:bg-yellow-500 focus:outline-none focus:border-yellow-700 focus:ring focus:ring-yellow-300;
      }
    </style>

    <div>
      <div class="count">
        Go for it! You'll be volunteer #{@count}
      </div>
      <Form for={@form} submit="save" change="validate">
        <Core.input field={@form[:name]} placeholder="Name" autocomplete="off" phx-debounce="2000" />
        <Core.input
          field={@form[:phone]}
          type="tel"
          placeholder="Phone"
          autocomplete="off"
          phx-debounce="blur"
        />
        <Core.button phx-disable-with="Saving...">
          Check In
        </Core.button>
      </Form>
    </div>
    """
  end

  def handle_event("validate", %{"volunteer" => volunteer_params}, socket) do
    changeset =
      %Volunteer{}
      |> Volunteers.change_volunteer(volunteer_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"volunteer" => volunteer_params}, socket) do
    case Volunteers.create_volunteer(volunteer_params) do
      {:ok, _volunteer} ->
        changeset = Volunteers.change_volunteer(%Volunteer{})

        {:noreply, assign(socket, :form, to_form(changeset))}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
