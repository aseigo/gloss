defmodule GlossWeb.LayoutView do
  use GlossWeb, :view

  def sections() do
    Gloss.Glossary.list_sections()
    |> Enum.reduce([], fn section, acc -> [[value: section.id, key: section.name] | acc] end)
    |> (fn [] -> [[key: "No sections", value: 0]]
           acc -> acc
        end).()
  end
end
