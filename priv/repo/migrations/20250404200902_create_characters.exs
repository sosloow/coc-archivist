defmodule CocArchivist.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters) do
      # Basic Information
      add :name, :string, null: false
      add :character_type, :string, null: false
      add :occupation, :string, null: false
      add :age, :integer, null: false
      add :sex, :string, null: false
      add :residence, :string
      add :birthplace, :string

      # Characteristics
      add :strength, :integer, null: false
      add :dexterity, :integer, null: false
      add :power, :integer, null: false
      add :constitution, :integer, null: false
      add :appearance, :integer, null: false
      add :education, :integer, null: false
      add :intelligence, :integer, null: false
      add :size, :integer, null: false

      # Derived Attributes
      add :hit_points, :integer
      add :magic_points, :integer
      add :sanity_points, :integer
      add :damage_bonus, :string

      # Skills (stored as JSON)
      add :skills, :map

      # Background
      add :background, :text
      add :personal_description, :text
      add :ideology_beliefs, :text
      add :significant_people, :text
      add :meaningful_locations, :text
      add :treasured_possessions, :text
      add :traits, :text

      # Equipment
      add :equipment, :map

      # Sanity
      add :current_sanity, :integer
      add :sanity_loss, :integer
      add :phobias, :text
      add :manias, :text

      # Additional Fields
      add :notes, :text
      add :portrait_url, :string

      timestamps(type: :utc_datetime)
    end

    create index(:characters, [:name])
    create index(:characters, [:character_type])
  end
end
