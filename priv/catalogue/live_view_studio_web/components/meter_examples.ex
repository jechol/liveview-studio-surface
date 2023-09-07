defmodule LiveViewStudioWeb.Components.MeterExamples do
  use Surface.Catalogue.Examples,
    subject: LiveViewStudioWeb.Components.Meter

  alias LiveViewStudioWeb.Components.Meter

  @example [
    title: "basic"
  ]
  def basic_meter_example(assigns) do
    ~F"""
    <Meter name="amount-of-gold" unit="T" value={10} />
    """
  end
end
