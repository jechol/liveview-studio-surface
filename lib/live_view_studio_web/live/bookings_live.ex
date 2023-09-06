defmodule LiveViewStudioWeb.BookingsLive do
  use LiveViewStudioWeb, :surface_live_view

  alias LiveViewStudio.Bookings
  import Number.Currency

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       bookings: Bookings.list_bookings(),
       selected_dates: nil
     )}
  end

  def render(assigns) do
    ~F"""
    <style>
      #bookings {
        @apply mt-8 max-w-3xl mx-auto text-center;
      }
      #bookings :deep(.flatpickr-calendar) {
        @apply mt-10 mx-auto;
      }
      #bookings #booking-calendar :deep(div.placeholder) {
        @apply flex items-center justify-center mx-auto w-1/2 h-24 border-4 border-dashed border-slate-400 text-slate-500;
      }
      #bookings .details {
        @apply max-w-xl mx-auto flex items-center justify-between my-6 text-lg;
      }
      #bookings .details .date {
        @apply text-slate-800 font-extrabold;
      }
      #bookings .details .nights {
        @apply font-medium text-slate-600;
      }
      #bookings .details .price {
        @apply font-extrabold text-sky-600;
      }
      #bookings button {
        @apply inline-flex items-center px-4 py-2 border-sky-400 text-sm shadow-sm font-medium rounded-md text-white bg-sky-500 transition ease-in-out duration-150 outline-none border border-transparent hover:bg-sky-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-sky-600;
      }
    </style>

    <h1>Bookings</h1>
    <div id="bookings">
      <div phx-update="ignore" id="wrapper">
        <div id="booking-calendar" phx-hook="Calendar"></div>
      </div>
      <div :if={@selected_dates} class="details">
        <div>
          <span class="date">
            {format_date(@selected_dates.from)}
          </span>
          -
          <span class="date">
            {format_date(@selected_dates.to)}
          </span>
          <span class="nights">
            ({total_nights(@selected_dates)} nights)
          </span>
        </div>
        <div class="price">
          {total_price(@selected_dates)}
        </div>
        <button phx-click="book-selected-dates">
          Book Dates
        </button>
      </div>
    </div>
    """
  end

  def handle_event("dates-picked", [from, to], socket) do
    {:noreply,
     assign(socket,
       selected_dates: %{
         from: parse_date(from),
         to: parse_date(to)
       }
     )}
  end

  def handle_event("unavailable-dates", _, socket) do
    {:reply, %{dates: socket.assigns.bookings}, socket}
  end

  def handle_event("book-selected-dates", _, socket) do
    %{selected_dates: selected_dates, bookings: bookings} = socket.assigns

    socket =
      socket
      |> assign(:bookings, [selected_dates | bookings])
      |> assign(:selected_dates, nil)
      |> push_event("add-unavailable-dates", selected_dates)

    {:noreply, socket}
  end

  def format_date(date) do
    Timex.format!(date, "%m/%d", :strftime)
  end

  def total_nights(%{from: from, to: to}) do
    Timex.diff(to, from, :days)
  end

  def total_price(selected_dates) do
    selected_dates
    |> total_nights()
    |> then(&(&1 * 100))
    |> number_to_currency(precision: 0)
  end

  def parse_date(date_string) do
    date_string |> Timex.parse!("{ISO:Extended}") |> Timex.to_date()
  end
end
