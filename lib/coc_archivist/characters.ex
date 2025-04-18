defmodule CocArchivist.Characters do
  @moduledoc """
  The Characters context.
  """

  import Ecto.Query, warn: false
  alias CocArchivist.Repo
  alias CocArchivist.Characters.Character

  @doc """
  Returns the list of characters.

  ## Examples

      iex> list_characters()
      [%Character{}, ...]

  """
  def list_characters do
    Character
    |> preload(:scenario)
    |> Repo.all()
  end

  @doc """
  Returns the list of characters for a specific scenario.

  ## Examples

      iex> list_characters_by_scenario(scenario_id)
      [%Character{}, ...]

  """
  def list_characters_by_scenario(scenario_id) do
    Character
    |> where([c], c.scenario_id == ^scenario_id)
    |> preload(:scenario)
    |> Repo.all()
  end

  @doc """
  Returns the list of characters filtered by type.

  ## Examples

      iex> list_characters_by_type("player_character")
      [%Character{}, ...]

  """
  def list_characters_by_type(type) when type in ["player_character", "npc", "monster"] do
    Character
    |> where([c], c.character_type == ^type)
    |> preload(:scenario)
    |> Repo.all()
  end

  @doc """
  Gets a single character.

  Raises `Ecto.NoResultsError` if the Character does not exist.

  ## Examples

      iex> get_character!(123)
      %Character{}

      iex> get_character!(456)
      ** (Ecto.NoResultsError)

  """
  def get_character!(id) do
    Character
    |> preload(:scenario)
    |> Repo.get!(id)
  end

  @doc """
  Creates a character.

  ## Examples

      iex> create_character(%{field: value})
      {:ok, %Character{}}

      iex> create_character(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_character(attrs \\ %{}) do
    %Character{}
    |> Character.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a character.

  ## Examples

      iex> update_character(character, %{field: new_value})
      {:ok, %Character{}}

      iex> update_character(character, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_character(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a character.

  ## Examples

      iex> delete_character(character)
      {:ok, %Character{}}

      iex> delete_character(character)
      {:error, %Ecto.Changeset{}}

  """
  def delete_character(%Character{} = character) do
    Repo.delete(character)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking character changes.

  ## Examples

      iex> change_character(character)
      %Ecto.Changeset{data: %Character{}}

  """
  def change_character(%Character{} = character, attrs \\ %{}) do
    Character.changeset(character, attrs)
  end

  @doc """
  Randomizes a character's characteristics and saves them to the database.
  """
  def randomize_characteristics(character) do
    random_characteristics = Character.random_characteristics()

    update_character(character, random_characteristics)
  end
end
