defmodule LiveViewStudioWeb.SalesLive do
  use LiveViewStudioWeb, :surface_live_view

  alias LiveViewStudio.Sales

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    {:ok, assign_stats(socket)}
  end

  def render(assigns) do
    ~F"""
    <style>
      #sales {
        @apply mt-8 max-w-2xl mx-auto;
      }
      #sales .stats {
        @apply mb-8 rounded-lg bg-white shadow-lg grid grid-cols-3;
      }
      #sales .stats .stat {
        @apply p-6 text-center;
      }
      #sales .stats .stat .label {
        @apply block mt-2 text-lg font-medium text-slate-500;
      }
      #sales .stats .stat .value {
        @apply block text-5xl font-extrabold text-indigo-600;
      }
      #sales button {
        @apply inline-flex items-center px-4 py-2 border border-indigo-300 text-sm shadow-sm font-medium rounded-md text-indigo-700 bg-indigo-100 transition ease-in-out duration-150 outline-none hover:bg-white active:bg-indigo-200;
      }
      #sales button img,
      #sales button svg {
        @apply mr-2 h-4 w-4;
      }
      #sales .controls {
        @apply flex items-center justify-end;
      }
      #sales .controls form {
        @apply flex items-center;
      }
      #sales .controls form label {
        @apply uppercase tracking-wide text-indigo-800 text-xs font-semibold mr-2;
      }
      #sales .controls form select {
        @apply appearance-none bg-slate-200 border-indigo-300 border text-indigo-700 py-0 pr-8 rounded-lg font-semibold cursor-pointer mr-2 h-10;
      }
      #sales .controls form select:focus {
        @apply outline-none bg-white border-indigo-500;
      }
      #sales .last-updated {
        @apply text-slate-700 text-sm;
      }
    </style>

    <h1>Snappy Sales 📊</h1>
    <div id="sales">
      <div class="stats">
        <div class="stat">
          <span class="value">
            {@new_orders}
          </span>
          <span class="label">
            New Orders
          </span>
        </div>
        <div class="stat">
          <span class="value">
            ${@sales_amount}
          </span>
          <span class="label">
            Sales Amount
          </span>
        </div>
        <div class="stat">
          <span class="value">
            {@satisfaction}%
          </span>
          <span class="label">
            Satisfaction
          </span>
        </div>
      </div>

      <button :on-click="refresh">
        <img src="/images/refresh.svg"> Refresh
      </button>
    </div>
    """
  end

  def handle_event("refresh", _, socket) do
    {:noreply, assign_stats(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, assign_stats(socket)}
  end

  defp assign_stats(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction()
    )
  end
end
