defmodule CocArchivist.Repo.Migrations.AddLckToCharacters do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :lck, :integer, default: 0, null: false
    end

    create constraint(:characters, :lck_range, check: "lck >= 0 AND lck <= 100")
  end
end
