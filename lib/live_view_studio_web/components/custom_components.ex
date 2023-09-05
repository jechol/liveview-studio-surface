defmodule LiveViewStudioWeb.CustomComponents do
  defmodule Promo do
    use Surface.Component

    prop expiration, :integer, default: 24

    slot legal
    slot default, required: true

    def render(assigns) do
      ~F"""
      <div class="promo">
        <div class="deal">
          <#slot />
        </div>
        <div class="expiration">
          Deal expires in {@expiration} hours
        </div>
        <div class="legal">
          <#slot {@legal} />
        </div>
      </div>
      """
    end
  end
end
