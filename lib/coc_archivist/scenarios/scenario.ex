defmodule CocArchivist.Scenarios.Scenario do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset

  schema "scenarios" do
    field :title, :string
    field :date, :date
    field :location, :string
    field :description, :string
    field :cover, CocArchivist.Uploaders.ImageUploader.Type

    # Associations
    has_many :characters, CocArchivist.Characters.Character

    timestamps()
  end

  @doc false
  def changeset(scenario, attrs) do
    scenario
    |> cast(attrs, [:title, :date, :location, :description])
    |> cast_attachments(attrs, [:cover], allow_paths: true)
    |> validate_required([:title, :date, :location, :description])
  end
end
