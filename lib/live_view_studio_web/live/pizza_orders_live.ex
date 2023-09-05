defmodule LiveViewStudioWeb.PizzaOrdersLive do
  use LiveViewStudioWeb, :surface_live_view

  alias LiveViewStudio.PizzaOrders
  import Number.Currency

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        pizza_orders: PizzaOrders.list_pizza_orders()
      )

    {:ok, socket}
  end
end
