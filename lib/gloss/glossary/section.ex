defmodule Gloss.Glossary.Section do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sections" do
    field :name, :string
  end

  @doc false
  def changeset(section, attrs) do
    section
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
