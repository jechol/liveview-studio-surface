defmodule LiveViewStudioWeb.ServersLive do
  use LiveViewStudioWeb, :surface_live_view

  alias LiveViewStudio.Servers

  alias Surface.Components.LivePatch
  alias Surface.Components.LiveRedirect

  def mount(_params, _session, socket) do
    IO.inspect(self(), label: "MOUNT")

    servers = Servers.list_servers()

    socket =
      assign(socket,
        servers: servers,
        coffees: 0
      )

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    IO.inspect(self(), label: "HANDLE PARAMS ID=#{id}")

    server = Servers.get_server!(id)

    {:noreply,
     assign(socket,
       selected_server: server,
       page_title: "What's up #{server.name}?"
     )}
  end

  def handle_params(_, _uri, socket) do
    IO.inspect(self(), label: "HANDLE PARAMS CATCH-ALL")

    {:noreply,
     assign(socket,
       selected_server: hd(socket.assigns.servers)
     )}
  end

  def render(assigns) do
    IO.inspect(self(), label: "RENDER")

    ~F"""
    <style>
      #servers {
        @apply mt-8 flex max-w-3xl mx-auto;
      }
      #servers .sidebar {
        @apply w-44 shadow;
      }
      #servers .sidebar .nav {
        @apply flex-1 pt-4 px-2 pb-2 bg-indigo-800 text-white rounded-l-lg h-full;
      }
      #servers .sidebar .nav .selected {
        @apply text-white bg-indigo-500;
      }
      #servers .sidebar .nav a {
        @apply text-sm font-semibold flex items-center px-2 py-3 rounded-md mb-2 cursor-pointer hover:text-white hover:bg-indigo-500;
      }
      #servers .sidebar .nav a span.up {
        @apply h-4 w-4 rounded-full mr-2 bg-green-400;
      }
      #servers .sidebar .nav a span.down {
        @apply h-4 w-4 rounded-full mr-2 bg-red-400;
      }
      #servers .sidebar .nav a.add {
        @apply text-sm text-slate-300 p-1 px-3 font-bold hover:bg-transparent hover:underline hover:text-white;
      }
      #servers .sidebar .coffees {
        @apply mt-4 flex items-center justify-center;
      }
      #servers .sidebar .coffees button {
        @apply flex items-center justify-around tabular-nums text-slate-700 text-xl font-semibold;
      }
      #servers .sidebar .coffees button img {
        @apply w-7 h-7 mr-2;
      }
      #servers .main {
        @apply flex flex-1;
      }
      #servers .main .wrapper {
        @apply flex-1 max-w-2xl mr-auto;
      }
      #servers .main h2 {
        @apply text-center text-2xl font-bold mb-4;
      }
      #servers .main .up {
        @apply px-3 py-1 text-sm font-medium bg-green-200 text-green-800 rounded-full;
      }
      #servers .main .down {
        @apply px-3 py-1 text-sm font-medium bg-red-200 text-red-800 rounded-full;
      }
      #servers .main .server {
        @apply bg-white shadow overflow-hidden rounded-r-lg h-full;
      }
      #servers .main .server .header {
        @apply px-6 py-5 border-b border-slate-200 flex items-center flex-wrap justify-between;
      }
      #servers .main .server .header h2 {
        @apply mb-0 text-xl font-semibold text-indigo-800;
      }
      #servers .main .server .body {
        @apply p-6;
      }
      #servers .main .server .body .row {
        @apply flex flex-wrap items-baseline justify-between text-base font-medium text-slate-600;
      }
      #servers .main .server .body h3 {
        @apply mt-8 text-left text-base font-medium text-slate-600 mb-2;
      }
      #servers .main .server .body blockquote {
        @apply mt-2 py-1 text-base text-slate-500;
      }
      #servers .main .links {
        @apply flex items-center justify-end space-x-4 mt-2;
      }
      #servers .main .links a {
        @apply text-lg text-slate-700 hover:underline hover:cursor-pointer;
      }
      #servers form {
        @apply bg-white p-6 shadow overflow-hidden rounded-r-lg h-full;
      }
      #servers form .field {
        @apply mb-4;
      }
      #servers form label {
        @apply block text-base font-medium text-slate-600 mb-2;
      }
      #servers form input[type="text"],
      #servers form input[type="number"] {
        @apply w-full appearance-none px-3 py-2 border border-slate-400 rounded-md transition duration-150 ease-in-out text-xl;
      }
      #servers form input[type="text"]:focus,
      #servers form input[type="number"]:focus {
        @apply outline-none border-indigo-300 ring ring-indigo-300;
      }
      #servers form button {
        @apply py-2 px-4 font-medium rounded-md text-white bg-indigo-500 transition duration-150 border border-transparent ease-in-out outline-none flex-initial text-base hover:bg-indigo-700;
      }
      #servers form a.cancel {
        @apply inline-block ml-2 py-2 px-4 border border-slate-600 font-medium rounded-md text-slate-600 text-base hover:bg-slate-700 hover:text-white;
      }
    </style>

    <h1>Servers</h1>
    <div id="servers">
      <div class="sidebar">
        <div class="nav">
          <LivePatch
            :for={server <- @servers}
            to={~p"/servers?#{[id: server]}"}
            class={selected: server == @selected_server}
          >
            <span class={server.status} />
            {server.name}
          </LivePatch>
        </div>
        <div class="coffees">
          <button :on-click="drink">
            <img src="/images/coffee.svg">
            {@coffees}
          </button>
        </div>
      </div>
      <div class="main">
        <div class="wrapper">
          <div class="server">
            <div class="header">
              <h2>{@selected_server.name}</h2>
              <span class={@selected_server.status}>
                {@selected_server.status}
              </span>
            </div>
            <div class="body">
              <div class="row">
                <span>
                  {@selected_server.deploy_count} deploys
                </span>
                <span>
                  {@selected_server.size} MB
                </span>
                <span>
                  {@selected_server.framework}
                </span>
              </div>
              <h3>Last Commit Message:</h3>
              <blockquote>
                {@selected_server.last_commit_message}
              </blockquote>
            </div>
          </div>
          <div class="links">
            <LiveRedirect to={~p"/topsecret"}>
              Top Secret
            </LiveRedirect>
            <LiveRedirect to={~p"/light"}>
              Adjust Lights
            </LiveRedirect>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("drink", _, socket) do
    IO.inspect(self(), label: "HANDLE DRINK EVENT")

    {:noreply, update(socket, :coffees, &(&1 + 1))}
  end
end
