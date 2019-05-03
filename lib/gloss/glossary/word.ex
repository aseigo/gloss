defmodule Gloss.Glossary.Word do
  use Ecto.Schema
  import Ecto.Changeset

  schema "words" do
    field :def, :string
    field :word, :string

    timestamps()

    belongs_to :section, Gloss.Glossary.Section
  end

  @doc false
  def changeset(word, attrs) do
    word
    |> cast(attrs, [:word, :def, :section_id])
    |> validate_required([:word, :def, :section_id])
  end
end
