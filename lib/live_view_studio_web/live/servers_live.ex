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
