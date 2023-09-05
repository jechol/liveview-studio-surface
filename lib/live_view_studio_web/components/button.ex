# defmodule LiveViewStudioWeb.CoreComponents.Button do
#   use LiveViewStudioWeb, :surface_component

#   prop type, :string, default: nil
#   prop class, :string, default: nil
#   prop rest, :global, include: ~w(disabled form name value)

#   slot default, required: true

#   def render(assigns) do
#     ~F"""
#     <button
#       type={@type}
#       class={[
#         "phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3",
#         "text-sm font-semibold leading-6 text-white active:text-white/80",
#         @class
#       ]}
#       {@rest}
#     >
#       <#slot />
#     </button>
#     """
#   end
# end
