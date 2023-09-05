defmodule LiveViewStudioWeb.Layouts do
  use LiveViewStudioWeb, :html

  embed_templates "layouts/*"
  embed_sface("layouts/root.sface")
  embed_sface("layouts/app.sface")
end
