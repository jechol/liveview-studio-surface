defmodule LiveViewStudioWeb.CustomComponents do
  defmodule Promo do
    use Surface.Component

    prop(expiration, :integer, default: 24)

    slot(legal)
    slot(default, required: true)

    def render(assigns) do
      ~F"""
      <style>
        .promo {
          @apply max-w-3xl mx-auto my-6 p-4 rounded-lg text-center text-white text-xl font-medium bg-gradient-to-r from-green-400 to-blue-500;
        }
        .promo .deal {
          @apply font-extrabold text-3xl flex items-center justify-center gap-2 drop-shadow-lg;
        }
        .promo .expiration {
          @apply text-sm font-bold uppercase mt-2 text-slate-900;
        }
        .promo .legal {
          @apply text-sm italic font-medium text-slate-300 flex items-center justify-end gap-1;
        }
        .promo :deep(svg) {
          @apply inline-flex w-6 h-6;
        }
      </style>

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
