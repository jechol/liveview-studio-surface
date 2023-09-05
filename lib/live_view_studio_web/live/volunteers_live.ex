defmodule LiveViewStudioWeb.VolunteersLive do
  use LiveViewStudioWeb, :surface_live_view

  alias LiveViewStudio.Volunteers
  alias LiveViewStudioWeb.Components, as: C
  alias LiveViewStudioWeb.LiveComponents, as: LC

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Volunteers.subscribe()
    end

    volunteers = Volunteers.list_volunteers()

    socket =
      socket
      |> stream(:volunteers, volunteers)
      |> assign(:count, length(volunteers))

    {:ok, socket}
  end

  def render(assigns) do
    ~F"""
    <h1>Volunteer Check-In</h1>
    <div id="volunteer-checkin">
      {!-- <.live_component module={VolunteerFormComponent} id={:new} count={@count} /> --}
      <LC.VolunteerForm id={:new} count={@count} />

      <div id="volunteers" phx-update="stream">
        <C.Volunteer
          :for={{dom_id, v} <- @streams.volunteers}
          {...C.Volunteer.to_prop(v)}
          id={dom_id}
          click="toggle-status"
        />
      </div>
    </div>
    """
  end

  def handle_event("toggle-status", %{"id" => id}, socket) do
    volunteer = Volunteers.get_volunteer!(id)

    {:ok, _volunteer} =
      Volunteers.update_volunteer(
        volunteer,
        %{checked_out: !volunteer.checked_out}
      )

    {:noreply, socket}
  end

  def handle_info({:volunteer_created, volunteer}, socket) do
    socket = update(socket, :count, &(&1 + 1))
    {:noreply, stream_insert(socket, :volunteers, volunteer, at: 0)}
  end

  def handle_info({:volunteer_updated, volunteer}, socket) do
    {:noreply, stream_insert(socket, :volunteers, volunteer)}
  end
end
