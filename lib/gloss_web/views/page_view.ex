defmodule GlossWeb.PageView do
  use GlossWeb, :view

  def letter_jumps() do
    Enum.reduce(90..65, [], fn x, acc -> [[x] | acc] end) |> Enum.join(" &middot; ")
  end
end
