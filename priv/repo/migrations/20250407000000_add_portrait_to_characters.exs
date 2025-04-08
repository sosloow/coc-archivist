defmodule CocArchivist.Repo.Migrations.AddPortraitToCharacters do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :portrait, :string
    end
  end
end
