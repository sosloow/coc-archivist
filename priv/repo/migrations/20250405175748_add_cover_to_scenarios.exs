defmodule CocArchivist.Repo.Migrations.AddCoverToScenarios do
  use Ecto.Migration

  def change do
    alter table(:scenarios) do
      add :cover, :string
    end
  end
end
