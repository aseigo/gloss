defmodule Gloss.Repo.Migrations.CreateWords do
  use Ecto.Migration

  def change do
    create table(:words) do
      add :word, :text
      add :def, :text
      add :section_id, references(:sections)

      timestamps()
    end

  end
end
