defmodule CocArchivist.Repo.Migrations.AddScenarioIdToCharacters do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :scenario_id, references(:scenarios, on_delete: :delete_all)
    end

    create index(:characters, [:scenario_id])
  end
end
