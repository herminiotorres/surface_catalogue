defmodule Surface.Catalogue.PlaygroundLive do
  use Surface.LiveView

  data playground, :module
  data head, :string
  data style, :string
  data class, :string
  data __window_id__, :string

  def mount(params, session, socket) do
    window_id = Surface.Catalogue.get_window_id(session, params)
    socket = assign(socket, :__window_id__, window_id)
    {:ok, socket, temporary_assigns: [event_log_entries: []]}
  end

  def handle_params(params, _uri, socket) do
    # TODO: validate component and playground view
    component = Module.safe_concat([params["component"]])
    playground = Module.safe_concat([params["component"], "Playground"])
    meta = Surface.Catalogue.get_metadata(playground)

    socket =
      socket
      |> assign(:component, component)
      |> assign(:playground, playground)
      |> assign(:head, meta[:head] || "")
      |> assign(:style, meta[:style] || "")
      |> assign(:class, meta[:class])

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <html lang="en">
      <head>
        {{ Phoenix.HTML.Tag.csrf_meta_tag() }}
        <meta charset="utf-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="initial-scale=1, maximum-scale=1, minimum-scale=1"/>
        {{ raw(@head) }}
        <script defer type="module" src="/js/app.js"></script>
      </head>
      <body style={{ @style }} class={{ @class }}>
        {{ live_render(@socket, @playground, id: "playground", session: %{"__window_id__" => @__window_id__}) }}
      </body>
    </html>
    """
  end
end