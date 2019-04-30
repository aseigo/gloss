defmodule Gloss.Repo.Migrations.AddSectionsTable do
  use Ecto.Migration

  def change do
    create table(:sections) do
      add :name, :text, null: false
    end
  end
end
