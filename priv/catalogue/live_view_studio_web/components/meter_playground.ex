defmodule LiveViewStudioWeb.Components.MeterPlayground do
  use Surface.Catalogue.Playground, subject: LiveViewStudioWeb.Components.Meter, height: "100px"

  @props [
    name: "number of pig",
    unit: "EA",
    value: 42
  ]
end
