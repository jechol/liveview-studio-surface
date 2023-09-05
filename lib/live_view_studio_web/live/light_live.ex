defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :surface_live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, brightness: 10)
    {:ok, socket}
  end

  def render(assigns) do
    ~F"""
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
