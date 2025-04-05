defmodule CocArchivist.ScenariosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CocArchivist.Scenarios` context.
  """

  @doc """
  Generate a scenario.
  """
  def scenario_fixture(attrs \\ %{}) do
    {:ok, scenario} =
      attrs
      |> Enum.into(%{
        date: ~D[2025-04-03],
        description: "some description",
        location: "some location",
        title: "some title"
      })
      |> CocArchivist.Scenarios.create_scenario()

    scenario
  end
end
