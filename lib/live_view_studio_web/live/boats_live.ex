defmodule LiveViewStudioWeb.BoatsLive do
  use LiveViewStudioWeb, :surface_live_view

  alias LiveViewStudio.Boats
  alias LiveViewStudioWeb.CustomComponents.Promo

  defmodule Boat do
    use Surface.Component

    prop(image, :string, required: true)
    prop(model, :string, required: true)
    prop(price, :string, required: true)
    prop(type, :string, required: true)

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

    prop(type, :string, required: true)
    prop(prices, :list, required: true)

    def render(assigns) do
      ~F"""
      <style>
        form {
          @apply max-w-xl mx-auto mb-4;
        }
        form .filters {
          @apply flex items-baseline justify-around;
        }
        form .filters select {
          @apply appearance-none w-1/3 bg-slate-200 border border-slate-400 text-slate-700 py-3 px-4 rounded-lg font-semibold cursor-pointer;
        }
        form .filters select:focus {
          @apply outline-none bg-slate-200 border-slate-500;
        }
        form .filters .prices {
          @apply flex;
        }
        form .filters .prices input[type="checkbox"] {
          @apply opacity-0 fixed w-0;
        }
        form .filters .prices input[type="checkbox"]:checked + label {
          @apply bg-indigo-300 border-indigo-500;
        }
        form .filters .prices label {
          @apply inline-block border-t border-b border-slate-400 bg-slate-300 py-3 px-4 text-lg font-semibold hover:bg-slate-400 hover:cursor-pointer;
        }
        form .filters .prices label:first-of-type {
          @apply border-l border-r rounded-l-lg;
        }
        form .filters .prices label:last-of-type {
          @apply border-l border-r rounded-r-lg;
        }
        form .filters a {
          @apply inline underline text-lg cursor-pointer;
        }
      </style>

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
    <style>
      #boats {
        @apply mt-8 max-w-4xl mx-auto;
      }
      #boats .boats {
        @apply my-10 grid gap-6 grid-cols-2 md:grid-cols-3;
      }
      #boats .boat {
        @apply max-w-sm rounded bg-white overflow-hidden shadow-lg;
      }
      #boats .boat img {
        @apply w-full;
      }
      #boats .boat .content {
        @apply px-6 py-4;
      }
      #boats .boat .model {
        @apply pb-3 text-center text-slate-900 font-bold text-xl;
      }
      #boats .boat .details {
        @apply px-6 mt-2 flex justify-between;
      }
      #boats .boat .price {
        @apply text-slate-700 font-semibold text-xl;
      }
      #boats .boat .type {
        @apply inline-block bg-slate-300 rounded-full px-3 py-1 text-sm font-semibold text-slate-700;
      }
    </style>

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
