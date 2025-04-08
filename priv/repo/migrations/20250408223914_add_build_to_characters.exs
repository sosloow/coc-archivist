defmodule CocArchivist.Repo.Migrations.AddBuildToCharacters do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :build, :integer, default: 0, null: false
    end
  end
end
