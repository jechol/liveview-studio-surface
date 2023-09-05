defmodule LiveViewStudioWeb.Components.VolunteerPlayground do
  alias LiveViewStudioWeb.Components, as: C

  use Surface.Catalogue.Playground,
    subject: C.Volunteer,
    height: "360px",
    body: [style: "padding: 1.5rem;"]

  alias LiveViewStudio.Volunteers.Volunteer

  @props [
    volunteer: %Volunteer{id: 1, name: "John", phone: "010-1234-5678", checked_out: false},
    id: "volunteer-1",
    click: nil
  ]
end
