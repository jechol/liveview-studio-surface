defmodule LiveViewStudioWeb.BoatsLive do
  use LiveViewStudioWeb, :surface_live_view

  alias LiveViewStudio.Boats
  alias LiveViewStudioWeb.CustomComponents.Promo

  defmodule Boat do
    use Surface.Component

    prop image, :string, required: true
    prop model, :string, required: true
    prop price, :string, required: true
    prop type, :string, required: true

    def render(assigns) do
      ~F"""
      <div class="boat">
        <img src={@image}>
        <div class="content">
          <div class="model">
            {@model}
          </div>
          <div class="details">
            <span class="price">
              {@price}
            </span>
            <span class="type">
              {@type}
            </span>
          </div>
        </div>
      </div>
      """
    end
  end

  defmodule FilterForm do
    use Surface.Component

    prop type, :string, required: true
    prop prices, :list, required: true

    def render(assigns) do
      ~F"""
      <form phx-change="filter">
        <div class="filters">
          <select name="type">
            {Phoenix.HTML.Form.options_for_select(
              type_options(),
              @type
            )}
          </select>
          <div class="prices">
            {#for price <- ["$", "$$", "$$$"]}
              <input type="checkbox" name="prices[]" value={price} id={price} checked={price in @prices}>
              <label for={price}>{price}</label>
            {/for}
            <input type="hidden" name="prices[]" value="">
          </div>
        </div>
      </form>
      """
    end

    defp type_options do
      [
        "All Types": "",
        Fishing: "fishing",
        Sporting: "sporting",
        Sailing: "sailing"
      ]
    end
  end

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        filter: %{type: "", prices: []},
        boats:
          Boats.list_boats()
          |> tap(fn boats ->
            boats |> List.first() |> IO.inspect()
          end)
      )

    {:ok, socket, temporary_assigns: [boats: []]}
  end

  def render(assigns) do
    ~F"""
    <h1>Daily Boat Rentals</h1>

    <Promo expiration={2}>
      Save 25% on rentals!
      <:legal>
        <Heroicons.exclamation_circle /> Limit 1 per party
      </:legal>
    </Promo>

    <div id="boats">
      <FilterForm {...@filter} />

      <div class="boats">
        <Boat :for={boat <- @boats} {...boat |> Map.take([:image, :model, :price, :type])} />
      </div>
    </div>

    <Promo>
      Hurry, only 3 boats left!
    </Promo>
    """
  end

  def handle_event("filter", %{"type" => type, "prices" => prices}, socket) do
    filter = %{type: type, prices: prices}

    boats = Boats.list_boats(filter)

    {:noreply, assign(socket, boats: boats, filter: filter)}
  end
end
