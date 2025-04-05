defmodule CocArchivist.ScenariosTest do
  use CocArchivist.DataCase

  alias CocArchivist.Scenarios

  describe "scenarios" do
    alias CocArchivist.Scenarios.Scenario

    import CocArchivist.ScenariosFixtures

    @invalid_attrs %{date: nil, description: nil, location: nil, title: nil}

    test "list_scenarios/0 returns all scenarios" do
      scenario = scenario_fixture()
      assert Scenarios.list_scenarios() == [scenario]
    end

    test "get_scenario!/1 returns the scenario with given id" do
      scenario = scenario_fixture()
      assert Scenarios.get_scenario!(scenario.id) == scenario
    end

    test "create_scenario/1 with valid data creates a scenario" do
      valid_attrs = %{date: ~D[2025-04-03], description: "some description", location: "some location", title: "some title"}

      assert {:ok, %Scenario{} = scenario} = Scenarios.create_scenario(valid_attrs)
      assert scenario.date == ~D[2025-04-03]
      assert scenario.description == "some description"
      assert scenario.location == "some location"
      assert scenario.title == "some title"
    end

    test "create_scenario/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scenarios.create_scenario(@invalid_attrs)
    end

    test "update_scenario/2 with valid data updates the scenario" do
      scenario = scenario_fixture()
      update_attrs = %{date: ~D[2025-04-04], description: "some updated description", location: "some updated location", title: "some updated title"}

      assert {:ok, %Scenario{} = scenario} = Scenarios.update_scenario(scenario, update_attrs)
      assert scenario.date == ~D[2025-04-04]
      assert scenario.description == "some updated description"
      assert scenario.location == "some updated location"
      assert scenario.title == "some updated title"
    end

    test "update_scenario/2 with invalid data returns error changeset" do
      scenario = scenario_fixture()
      assert {:error, %Ecto.Changeset{}} = Scenarios.update_scenario(scenario, @invalid_attrs)
      assert scenario == Scenarios.get_scenario!(scenario.id)
    end

    test "delete_scenario/1 deletes the scenario" do
      scenario = scenario_fixture()
      assert {:ok, %Scenario{}} = Scenarios.delete_scenario(scenario)
      assert_raise Ecto.NoResultsError, fn -> Scenarios.get_scenario!(scenario.id) end
    end

    test "change_scenario/1 returns a scenario changeset" do
      scenario = scenario_fixture()
      assert %Ecto.Changeset{} = Scenarios.change_scenario(scenario)
    end
  end
end
