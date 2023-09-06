defmodule LiveViewStudioWeb.FlightsLive do
  use LiveViewStudioWeb, :surface_live_view

  alias LiveViewStudio.Flights
  alias LiveViewStudio.Airports

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        airport: "",
        flights: [],
        loading: false,
        matches: %{}
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~F"""
    <style>
      #flights {
        @apply mt-8 max-w-3xl mx-auto text-center;
      }
      #flights form {
        @apply inline-flex items-center px-2;
      }
      #flights form input[type="text"] {
        @apply h-10 border border-slate-400 rounded-l-md bg-white px-5 text-base;
      }
      #flights form input[type="text"]:focus {
        @apply outline-none;
      }
      #flights button {
        @apply h-10 px-3 py-2 bg-transparent border border-slate-400 border-l-0 rounded-r-md transition ease-in-out duration-150 outline-none hover:bg-slate-300;
      }
      #flights button img,
      #flights button svg {
        @apply h-5 w-5;
      }
      #flights .flights {
        @apply my-8 bg-white shadow overflow-hidden rounded-md;
      }
      #flights .flights li {
        @apply border-t border-slate-300 px-6 py-4 hover:bg-indigo-100;
      }
      #flights .flights li .first-line {
        @apply flex items-center justify-between;
      }
      #flights .flights li .first-line .number {
        @apply text-lg font-semibold text-indigo-600 truncate;
      }
      #flights .flights li .first-line .origin-destination {
        @apply mt-0 flex items-center text-base text-indigo-600;
      }
      #flights .flights li .first-line .origin-destination img,
      #flights .flights li .first-line .origin-destination svg {
        @apply flex-shrink-0 mr-1 h-5 w-5;
      }
      #flights .flights li .second-line {
        @apply mt-2 flex justify-between;
      }
      #flights .flights li .second-line .departs {
        @apply text-slate-500;
      }
      #flights .flights li .second-line .arrives {
        @apply text-slate-500;
      }
    </style>

    <h1>Find a Flight</h1>
    <div id="flights">
      <form :on-submit="search" :on-change="suggest">
        <input
          type="text"
          name="airport"
          value={@airport}
          placeholder="Airport Code"
          autofocus
          autocomplete="off"
          readonly={@loading}
          list="matches"
          phx-debounce="1000"
        />

        <button>
          <img src="/images/search.svg">
        </button>
      </form>

      <datalist id="matches">
        <option :for={{code, name} <- @matches} value={code}>
          {name}
        </option>
      </datalist>

      <div :if={@loading} class="loader">Loading...</div>

      <div class="flights">
        <ul>
          <li :for={flight <- @flights}>
            <div class="first-line">
              <div class="number">
                Flight #{flight.number}
              </div>
              <div class="origin-destination">
                {flight.origin} to {flight.destination}
              </div>
            </div>
            <div class="second-line">
              <div class="departs">
                Departs: {flight.departure_time}
              </div>
              <div class="arrives">
                Arrives: {flight.arrival_time}
              </div>
            </div>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def handle_event("suggest", %{"airport" => prefix}, socket) do
    matches = Airports.suggest(prefix)
    {:noreply, assign(socket, matches: matches)}
  end

  def handle_event("search", %{"airport" => airport}, socket) do
    send(self(), {:run_search, airport})

    socket =
      assign(socket,
        airport: airport,
        flights: [],
        loading: true
      )

    {:noreply, socket}
  end

  def handle_info({:run_search, airport}, socket) do
    socket =
      assign(socket,
        flights: Flights.search_by_airport(airport),
        loading: false
      )

    {:noreply, socket}
  end
end
