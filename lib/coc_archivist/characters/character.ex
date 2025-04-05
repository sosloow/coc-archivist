defmodule CocArchivist.Characters.Character do
  use Ecto.Schema
  import Ecto.Changeset

  schema "characters" do
    # Basic Information
    field :name, :string
    field :character_type, Ecto.Enum, values: [:player_character, :npc, :monster]
    field :occupation, :string
    field :age, :integer
    field :sex, :string
    field :residence, :string
    field :birthplace, :string

    # Characteristics (abbreviated)
    field :str, :integer
    field :dex, :integer
    field :pow, :integer
    field :con, :integer
    field :app, :integer
    field :edu, :integer
    field :int, :integer
    field :siz, :integer

    # Derived Attributes
    field :hp, :integer
    field :mp, :integer
    field :san, :integer
    field :db, :string

    # Skills (stored as JSON)
    field :skills, :map

    # Background
    field :background, :string
    field :personal_description, :string
    field :ideology_beliefs, :string
    field :significant_people, :string
    field :meaningful_locations, :string
    field :treasured_possessions, :string
    field :traits, :string

    # Equipment
    field :equipment, :map

    # Sanity
    field :current_sanity, :integer
    field :sanity_loss, :integer
    field :phobias, :string
    field :manias, :string

    # Additional Fields
    field :notes, :string
    field :portrait_url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [
      :name,
      :character_type,
      :occupation,
      :age,
      :sex,
      :residence,
      :birthplace,
      :str,
      :dex,
      :pow,
      :con,
      :app,
      :edu,
      :int,
      :siz,
      :hp,
      :mp,
      :san,
      :db,
      :skills,
      :background,
      :personal_description,
      :ideology_beliefs,
      :significant_people,
      :meaningful_locations,
      :treasured_possessions,
      :traits,
      :equipment,
      :current_sanity,
      :sanity_loss,
      :phobias,
      :manias,
      :notes,
      :portrait_url
    ])
    |> validate_required([
      :name,
      :character_type,
      :occupation,
      :age,
      :sex,
      :str,
      :dex,
      :pow,
      :con,
      :app,
      :edu,
      :int,
      :siz
    ])
    |> validate_number(:age, greater_than: 0, less_than: 100)
    |> validate_number(:str, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:dex, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:pow, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:con, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:app, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:edu, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:int, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:siz, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> calculate_derived_attributes()
  end

  defp calculate_derived_attributes(changeset) do
    if get_change(changeset, :siz) && get_change(changeset, :con) do
      siz = get_field(changeset, :siz)
      con = get_field(changeset, :con)
      hp = div(siz + con, 10)
      mp = get_field(changeset, :pow)
      san = get_field(changeset, :pow)

      changeset
      |> put_change(:hp, hp)
      |> put_change(:mp, mp)
      |> put_change(:san, san)
      |> put_change(:current_sanity, san)
      |> calculate_damage_bonus(siz, get_field(changeset, :str))
    else
      changeset
    end
  end

  defp calculate_damage_bonus(changeset, siz, str) do
    combined = siz + str

    damage_bonus =
      cond do
        combined < 65 -> "-2"
        combined < 85 -> "-1"
        combined < 125 -> "0"
        combined < 145 -> "+1D4"
        combined < 165 -> "+1D6"
        true -> "+2D6"
      end

    put_change(changeset, :db, damage_bonus)
  end
end
