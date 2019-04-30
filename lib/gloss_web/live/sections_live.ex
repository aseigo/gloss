defmodule Gloss.SectionsLive do
  use Phoenix.LiveView
  import Phoenix.HTML.Form
  require Logger

  def render(assigns) do
    IO.inspect(assigns, label: "Assign")
    ~L"""
    <form phx-change="change_section">
      <%= select(:section, :section, GlossWeb.LayoutView.sections()) %>
    </form>
    """
  end

  def mount(_session, socket) do
    {:ok, socket}
  end

  def handle_event("change_section", v, socket) do
    Logger.debug("Got #{inspect v}")
    {:noreply, socket}
  end
end
