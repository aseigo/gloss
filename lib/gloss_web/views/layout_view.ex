defmodule GlossWeb.LayoutView do
  use GlossWeb, :view

  def sections() do
    Gloss.Glossary.list_sections()
    |> Enum.reduce([], fn section, acc -> [[key: section.name, value: section.id] | acc] end)
  end
end
