defmodule LiveViewStudioWeb.SandboxLive do
  use LiveViewStudioWeb, :surface_live_view

  import Number.Currency
  alias LiveViewStudio.Sandbox
  alias LiveViewStudioWeb.Components, as: C

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        length: "0",
        width: "0",
        depth: "0",
        weight: 0.0,
        price: nil
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~F"""
    <style>
      #sandbox {
        @apply mt-8 max-w-lg mx-auto;
      }
      #sandbox form {
        @apply mx-auto mb-6 p-6 border border-slate-300 rounded-lg shadow-lg bg-white text-center;
      }
      #sandbox form .fields {
        @apply flex items-baseline justify-center space-x-4 mb-6;
      }
      #sandbox form .fields label {
        @apply block text-sm font-semibold text-slate-700;
      }
      #sandbox form .fields input[type="number"] {
        @apply focus:ring-indigo-300 focus:border-indigo-300 block w-full min-w-0 pl-6 pr-16 text-sm border-slate-300 rounded-md transition duration-150 ease-in-out appearance-none;
      }
      #sandbox form .fields .input {
        @apply mt-1 relative rounded-md shadow-sm;
      }
      #sandbox form .fields .unit {
        @apply absolute inset-y-0 right-0 pr-4 flex items-center pointer-events-none text-slate-500 text-sm;
      }
      #sandbox form .weight {
        @apply mt-4 block text-base font-bold text-slate-700;
      }
      #sandbox form button {
        @apply py-2 px-4 mt-6 border border-transparent font-semibold text-base rounded-md text-white bg-green-500 transition duration-150 ease-in-out outline-none hover:bg-green-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500;
      }
      #sandbox .quote {
        @apply text-center p-6 border-4 border-dotted border-green-600 text-xl font-semibold text-green-600;
      }
    </style>


    <h1>Build A Sandbox</h1>
    <div id="sandbox">
      <form :on-change="calculate" :on-submit="get-quote">
        <div class="fields">
          <div>
            <label for="length">Length</label>
            <C.Meter name="length" value={@length} unit="feet" />
          </div>
          <div>
            <label for="width">Width</label>
            <C.Meter name="width" value={@width} unit="feet" />
          </div>
          <div>
            <label for="depth">Depth</label>
            <C.Meter name="depth" value={@depth} unit="inches" />
          </div>
        </div>
        <div class="weight">
          You need {@weight} pounds of sand 🏝
        </div>
        <button type="submit">
          Get A Quote
        </button>
      </form>
      <div :if={@price} class="quote">
        Get your personal beach today for only {number_to_currency(@price)}
      </div>
    </div>
    """
  end

  def handle_event("get-quote", _, socket) do
    price = Sandbox.calculate_price(socket.assigns.weight)

    {:noreply, assign(socket, price: price)}
  end

  def handle_event("calculate", params, socket) do
    %{"length" => l, "width" => w, "depth" => d} = params
    weight = Sandbox.calculate_weight(l, w, d)

    socket =
      assign(socket,
        length: l,
        width: w,
        depth: d,
        weight: weight,
        price: nil
      )

    {:noreply, socket}
  end
end
