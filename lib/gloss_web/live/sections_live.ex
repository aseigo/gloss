defmodule Gloss.SectionsLive do
  use Phoenix.LiveView
  import Phoenix.HTML.Form
  require Logger

  def render(assigns) do
    GlossWeb.PageView.render("section_selector.html", assigns)
  end

  def mount(_session, socket) do
    #TODO: go to the last section they were previously viewing

    if (connected?(socket)) do
      Phoenix.PubSub.subscribe(Gloss.PubSub, self(), "sections")
    end

    {:ok, assign_sections(socket)}
  end

  def handle_event("change_section", v, socket) do
    Logger.debug("Got #{inspect v}")
    {:noreply, socket}
  end

  def handle_info(:changed, socket) do
    {:noreply, assign_sections(socket)}
  end

  defp assign_sections(socket) do
    assign(socket, sections: GlossWeb.LayoutView.sections())
  end
end
