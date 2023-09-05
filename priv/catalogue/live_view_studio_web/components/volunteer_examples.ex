defmodule LiveViewStudioWeb.Components.VolunteerExamples do
  alias LiveViewStudioWeb.Components, as: C

  use Surface.Catalogue.Examples, subject: C.Volunteer
  alias LiveViewStudio.Volunteers.Volunteer
  require C.Volunteer

  @example [
    title: "Wrapped",
    height: "400px"
  ]

  def wrapped_example(assigns) do
    ~F"""
    <h1>Volunteer Check-In</h1>
    <div id="volunteer-checkin">
      <div id="volunteers">
        <C.Volunteer
          :for={volunteer <- volunteers()}
          volunteer={volunteer}
          id={"volunteer-#{volunteer.id}"}
          click={nil}
        />
      </div>
    </div>
    """
  end

  @example [
    title: "Naked",
    height: "400px"
  ]

  def naked_example(assigns) do
    ~F"""
    <C.Volunteer
      :for={volunteer <- volunteers()}
      volunteer={volunteer}
      id={"volunteer-#{volunteer.id}"}
      click={nil}
    />
    """
  end

  defp volunteers() do
    [
      %Volunteer{id: 1, name: "John", phone: "010-1234-5678", checked_out: false},
      %Volunteer{id: 2, name: "Chris", phone: "010-1234-5678", checked_out: true}
    ]
  end
end
