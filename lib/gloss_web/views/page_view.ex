defmodule GlossWeb.PageView do
  use GlossWeb, :view

  def letter_jumps() do
    Enum.reduce(90..65, [], fn x, acc -> [[x] | acc] end) |> Enum.join(" &middot; ")
  end

  def current_section() do
    
  end

  def wordlist(category_id, prefix) do
    Gloss.Glossary.list_words(category_id, prefix)
  end
end
