defmodule CocArchivist.Characters.Character do
  use Ecto.Schema
  import Ecto.Changeset
  use Waffle.Ecto.Schema
  import CocArchivist.Dice

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
    field :lck, :integer
    field :mov, :integer

    # Derived Attributes
    field :hp, :integer
    field :mp, :integer
    field :san, :integer
    field :db, :string
    field :build, :integer
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
    field :equipment, :string

    # Sanity
    field :current_sanity, :integer
    field :sanity_loss, :integer
    field :phobias, :string
    field :manias, :string

    # Additional Fields
    field :notes, :string
    field :portrait, CocArchivist.Uploaders.ImageUploader.Type

    # Associations
    belongs_to :scenario, CocArchivist.Scenarios.Scenario

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
      :lck,
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
      :scenario_id
    ])
    |> cast_attachments(attrs, [:portrait])
    |> validate_required([
      :name,
      :character_type,
      :occupation
    ])
    |> validate_number(:age, greater_than: 15, less_than: 95)
    |> validate_number(:str, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:dex, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:pow, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:con, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:app, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:edu, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:int, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:siz, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:lck, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> calculate_derived_attributes()
  end

  defp calculate_derived_attributes(changeset) do
    siz = get_field(changeset, :siz)
    con = get_field(changeset, :con)
    str = get_field(changeset, :str)
    dex = get_field(changeset, :dex)
    age = get_field(changeset, :age)

    hp = div(siz + con, 10)
    mp = div(get_field(changeset, :pow), 10)
    san = get_field(changeset, :pow)

    changeset
    |> put_change(:hp, hp)
    |> put_change(:mp, mp)
    |> put_change(:san, san)
    |> put_change(:current_sanity, san)
    |> calculate_damage_bonus_and_build(siz, str)
    |> calculate_mov(siz, str, dex, age)
  end

  defp calculate_mov(changeset, siz, str, dex, age) do
    base_mov = 7
    slow_age = 30

    mov =
      base_mov +
        if(dex > siz, do: 1, else: 0) +
        if(str > siz, do: 1, else: 0) -
        max(div(age - slow_age, 10), 0)

    put_change(changeset, :mov, max(mov, 0))
  end

  defp calculate_damage_bonus_and_build(changeset, siz, str) do
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

    build =
      cond do
        combined < 65 -> -2
        combined < 85 -> -1
        combined < 125 -> 0
        combined < 145 -> 1
        true -> 2
      end

    put_change(changeset, :db, damage_bonus)
    |> put_change(:build, build)
  end

  @doc """
  Generates random characteristics for a character and returns an updated changeset.
  """
  def random_characteristics() do
    %{
      str: roll_dice(3, 6) * 5,
      dex: roll_dice(3, 6) * 5,
      pow: roll_dice(3, 6) * 5,
      con: roll_dice(3, 6) * 5,
      app: roll_dice(3, 6) * 5,
      edu: roll_dice(2, 6) * 5 + 30,
      int: roll_dice(2, 6) * 5 + 30,
      siz: roll_dice(2, 6) * 5 + 30,
      lck: roll_dice(3, 6) * 5
    }
  end
end
