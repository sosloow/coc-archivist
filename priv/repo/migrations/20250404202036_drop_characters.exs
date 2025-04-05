defmodule CocArchivist.Repo.Migrations.DropCharacters do
  use Ecto.Migration

  def change do
    drop table(:characters)
  end
end
