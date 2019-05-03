defmodule Gloss.SectionsLive do
  use Phoenix.LiveView

  def render(assigns) do
    GlossWeb.PageView.render("section_selector.html", assigns)
  end

  def mount(_session, socket) do
    if (connected?(socket)) do
      Phoenix.PubSub.subscribe(Gloss.PubSub, self(), "sections")
    end

    {:ok, assign_sections(socket)}
  end

  def handle_event("change_section", %{"section" => %{"section" => v}}, socket) do
    IO.inspect(v, label: "section selected")
    Phoenix.PubSub.broadcast(Gloss.PubSub, "sections", {:selected_section, v})
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