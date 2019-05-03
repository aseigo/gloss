defmodule GlossWeb.PageLive do
  use Phoenix.LiveView

  def render(assigns) do
    GlossWeb.PageView.render("glossary.html", assigns)
  end

  def mount(_session, socket) do
    if (connected?(socket)) do
      Phoenix.PubSub.subscribe(Gloss.PubSub, self(), "sections")
    end

    current_section = GlossWeb.LayoutView.sections() |> Enum.at(0) |> Keyword.get(:value)
                      |> IO.inspect(label: "current section")
    {:ok, assign(socket, current_section: current_section, current_word: nil)}
  end

  def handle_event("show_word", payload, socket) do
    id =
      case Integer.parse(payload) do
        {v, _} -> v
        :error -> nil
      end

      #TODO: show the def!
    {:noreply, assign(socket, current_word: id)}
  end

  def handle_info({:selected_section, section}, socket) do
    IO.puts("NEW SELECT SECTION #{inspect section}")
    {:noreply, assign(socket, current_section: section, current_word: nil)}
  end
end
