defmodule CocArchivist.Repo.Migrations.AddMovToCharacters do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :mov, :integer, default: 0, null: false
    end
  end
end
