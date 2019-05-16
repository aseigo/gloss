defmodule GlossWeb.PageLive do
  use Phoenix.LiveView

  def render(assigns) do
    GlossWeb.PageView.render("glossary.html", assigns)
  end

  def mount(%{path_params: %{"id" => id_param}}, socket) when is_bitstring(id_param) do
    id =
    case Integer.parse(id_param) do
      :error -> nil
      {id, _} -> id
    end
    assign(socket, :current_word, id) |> do_mount()
  end

  def mount(_session, socket), do: do_mount(socket)

  defp do_mount(socket) do
    if (connected?(socket)) do
      Phoenix.PubSub.subscribe(Gloss.PubSub, "sections")
    end

    current_section = GlossWeb.LayoutView.sections() |> Enum.at(0) |> Keyword.get(:value)
    {:ok, socket
          |> assign(current_word: Map.get(socket.assigns, :current_word), create_word: nil, edit_word: nil)
          |> assign_current_section(current_section)
          |> assign_sections()
          |> update_word_list(current_section)
    }
  end

  def handle_event("edit_current_word", _payload, socket) do
    edit_word = Gloss.Glossary.Word.changeset(%Gloss.Glossary.Word{},
                                              socket.assigns.current_word
                                              |> Gloss.Glossary.get_word!()
                                              |> Map.from_struct())
    {:noreply, assign(socket, edit_word: edit_word, create_word: nil)}
  end

  def handle_event("save_word", payload, socket) do
    data = Map.get(payload, "word")

    data =
      case Map.get(data, "new_section") do
        "" -> data
        new_section ->
          {:ok, section} = Gloss.Glossary.create_section(%{name: new_section})
          Map.put(data, "section_id", section.id)
    end

    Gloss.Glossary.get_word!(socket.assigns.current_word)
    |> Gloss.Glossary.update_word(data)

    current_section = Map.get(data, "section_id")
    {:noreply, socket 
               |> assign(create_word: nil, edit_word: nil)
               |> assign_current_section(current_section)
               |> update_word_list(current_section)
    }
  end

  def handle_event("new_word", _payload, socket) do
    word = %Gloss.Glossary.Word{} |> Ecto.Changeset.cast(%{section_id: socket.assigns.current_section}, [:section_id])
    #IO.puts("#{inspect socket.assigns.current_section} New word #{inspect word}")
    {:noreply, assign(socket, current_word: nil, edit_word: nil, create_word: word)}
  end

  def handle_event("create_word", payload, socket) do
    data = Map.get(payload, "word")

    data =
      case Map.get(data, "new_section") do
        "" -> data
        new_section ->
          {:ok, section} = Gloss.Glossary.create_section(%{name: new_section})
          Map.put(data, "section_id", section.id)
    end

    {:ok, word} = Gloss.Glossary.create_word(data)
    current_section = Map.get(data, "section_id")

    {:noreply, socket
               |> assign(create_word: nil, edit_word: nil, current_word: word.id)
               |> assign_current_section(current_section)
               |> update_word_list(current_section)
    }
  end

  def handle_event("show_word", payload, socket) do
    id =
      case Integer.parse(payload) do
        {v, _} -> v
        :error -> nil
      end

    {:noreply, assign(socket, current_word: id, create_word: nil, edit_word: nil)}
  end

  def handle_event("section_select", %{"section_selector" => %{"section_selector" => ""}}, socket) do
    {:noreply, socket}
  end

  def handle_event("section_select", %{"section_selector" => %{"section_selector" => v}}, socket) do
    IO.puts("Changing section to #{v}")
    {:noreply, socket
    |> assign(edit_word: nil, create_word: nil, current_word: nil)
    |> assign_current_section(v)
               |> update_word_list(v)}
  end

  def handle_info(_, socket) do
    {:noreply, assign_sections(socket)}
  end

  defp assign_sections(socket) do
    assign(socket, sections: GlossWeb.LayoutView.sections())
  end

  defp assign_current_section(socket, section) do
    assign(socket, current_section: section)
  end

  defp update_word_list(socket, section) do
    assign(socket, words: Gloss.Glossary.list_words(section))
  end
end
