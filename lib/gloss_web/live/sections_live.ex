defmodule Gloss.SectionsLive do
  use Phoenix.LiveView

  def render(assigns) do
    GlossWeb.PageView.render("section_selector.html", assigns)
  end

  def mount(_session, socket) do
    IO.inspect(socket, label: "mounted socket in page live")
    if (connected?(socket)) do
      Phoenix.PubSub.subscribe(Gloss.PubSub, "sections")
    end

    {:ok, assign_sections(socket)}
  end

  def handle_event("change_section", %{"section" => %{"section" => v}}, socket) do
    Phoenix.PubSub.broadcast(Gloss.PubSub, socket.id, {:selected_section, v})
    {:noreply, socket}
  end

  def handle_info(:sections_changed, socket) do
    {:noreply, assign_sections(socket)}
  end

  def handle_info(_, socket) do
    {:noreply, assign_sections(socket)}
  end

  defp assign_sections(socket) do
    assign(socket, sections: GlossWeb.LayoutView.sections())
  end
end
