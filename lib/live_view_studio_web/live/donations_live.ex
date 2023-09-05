defmodule LiveViewStudioWeb.DonationsLive do
  use LiveViewStudioWeb, :surface_live_view

  alias Surface.Components.LivePatch
  alias LiveViewStudio.Donations

  defmodule SortLink do
    use LiveViewStudioWeb, :surface_component

    prop sort_by, :atom, required: true
    prop options, :map, required: true

    slot default, required: true

    def render(%{sort_by: sort_by, options: options} = assigns) do
      options = %{
        options
        | sort_by: sort_by,
          sort_order: next_sort_order(options.sort_order)
      }

      ~F"""
      <LivePatch to={~p"/donations?#{options}"}>
        <#slot />
      </LivePatch>
      """
    end

    defp next_sort_order(sort_order) do
      case sort_order do
        :asc -> :desc
        :desc -> :asc
      end
    end
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    sort_by = (params["sort_by"] || "id") |> String.to_atom()
    sort_order = (params["sort_order"] || "asc") |> String.to_atom()

    page = (params["page"] || "1") |> String.to_integer()
    per_page = (params["per_page"] || "5") |> String.to_integer()

    options = %{
      sort_by: sort_by,
      sort_order: sort_order,
      page: page,
      per_page: per_page
    }

    donations = Donations.list_donations(options)

    socket =
      assign(socket,
        donations: donations,
        options: options
      )

    {:noreply, socket}
  end

  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    params = %{socket.assigns.options | per_page: per_page}

    socket = push_patch(socket, to: ~p"/donations?#{params}")

    {:noreply, socket}
  end
end
