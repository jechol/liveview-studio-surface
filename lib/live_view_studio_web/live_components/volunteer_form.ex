defmodule LiveViewStudioWeb.LiveComponents.VolunteerForm do
  use LiveViewStudioWeb, :surface_live_component

  alias LiveViewStudio.Volunteers
  alias LiveViewStudio.Volunteers.Volunteer
  alias Phoenix.Component, as: PC
  alias LiveViewStudioWeb.CoreComponents, as: Core
  alias Surface.Components.Form

  prop count, :integer, required: true

  data form, :any

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
