defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :surface_live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, brightness: 30)
    {:ok, socket}
  end

  def render(assigns) do
    ~F"""
    <style>
      #light {
        @apply mt-8 max-w-xl mx-auto text-center;
      }
      #light button {
        @apply bg-transparent mx-1 py-2 px-4 border-slate-400 border-2 rounded-lg shadow-sm transition ease-in-out duration-150 outline-none hover:bg-slate-300 disabled:opacity-50 disabled:cursor-not-allowed;
      }
      #light img,
      #light svg {
        @apply w-8;
      }
      #light .meter {
        @apply flex h-12 overflow-hidden text-base bg-slate-300 rounded-lg mb-8;
      }
      #light .meter > span {
        @apply flex flex-col justify-center text-slate-900 text-center whitespace-nowrap bg-yellow-300 font-bold w-0;
        transition: width 2s ease;
      }
      #light form {
        @apply mt-10;
      }
      #light form .temps {
        @apply flex justify-center items-center space-y-0 space-x-10;
      }
      #light form .temps > div {
        @apply flex items-center;
      }
      #light form .temps > div input {
        @apply h-4 w-4 border-slate-300 text-slate-600 focus:ring-slate-500;
      }
      #light form .temps > div label {
        @apply ml-2 block text-sm font-bold text-slate-700;
      }
    </style>

    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={width: "#{@brightness}%"}>
          {@brightness}%
        </span>
      </div>
      <button :on-click="off">
        <img src="/images/light-off.svg">
      </button>
      <button :on-click="down">
        <img src="/images/down.svg">
      </button>
      <button :on-click="up">
        <img src="/images/up.svg">
      </button>
      <button :on-click="on">
        <img src="/images/light-on.svg">
      </button>
    </div>
    """
  end

  def handle_event("on", _, socket) do
    socket = assign(socket, brightness: 100)
    {:noreply, socket}
  end

  def handle_event("up", _, socket) do
    socket = update(socket, :brightness, &(&1 + 10))
    {:noreply, socket}
  end

  def handle_event("down", _, socket) do
    socket = update(socket, :brightness, &(&1 - 10))
    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    socket = assign(socket, brightness: 0)
    {:noreply, socket}
  end
end
