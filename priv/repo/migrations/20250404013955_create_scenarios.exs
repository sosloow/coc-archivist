defmodule CocArchivist.Repo.Migrations.CreateScenarios do
  use Ecto.Migration

  def change do
    create table(:scenarios) do
      add :title, :string
      add :description, :text
      add :location, :string
      add :date, :date

      timestamps(type: :utc_datetime)
    end
  end
end
