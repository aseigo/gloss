defmodule GlossWeb.PageView do
  use GlossWeb, :view
  import Ecto.Query, only: [from: 2]

  def letter_jumps(current_section) do
    query = from l in "words",
      select: fragment("left(?, 1)", l.word),
      where: l.section_id == ^current_section,
      group_by: l.word,
      order_by: fragment("left(?, 1)", l.word)

    letters = query
              |> Gloss.Repo.all()
              |> Enum.reduce(MapSet.new(), &(MapSet.put(&2, &1)))

    Enum.reduce(?Z..?A, [], fn x, acc -> [jump_text([x], letters) | acc] end)
    |> Enum.join(" &middot; ")
  end

  def wordlist(category_id, prefix) do
    Gloss.Glossary.list_words(category_id, prefix)
  end

  defp jump_text(x, letters) do
    if MapSet.member?(letters, to_string([x])) do
      ~s(<a href="##{x}">#{x}</a>)
    else
      x
    end
  end
end
