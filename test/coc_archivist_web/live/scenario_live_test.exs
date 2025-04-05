defmodule CocArchivistWeb.ScenarioLiveTest do
  use CocArchivistWeb.ConnCase

  import Phoenix.LiveViewTest
  import CocArchivist.ScenariosFixtures

  @create_attrs %{date: "2025-04-03", description: "some description", location: "some location", title: "some title"}
  @update_attrs %{date: "2025-04-04", description: "some updated description", location: "some updated location", title: "some updated title"}
  @invalid_attrs %{date: nil, description: nil, location: nil, title: nil}

  defp create_scenario(_) do
    scenario = scenario_fixture()
    %{scenario: scenario}
  end

  describe "Index" do
    setup [:create_scenario]

    test "lists all scenarios", %{conn: conn, scenario: scenario} do
      {:ok, _index_live, html} = live(conn, ~p"/scenarios")

      assert html =~ "Listing Scenarios"
      assert html =~ scenario.description
    end

    test "saves new scenario", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/scenarios")

      assert index_live |> element("a", "New Scenario") |> render_click() =~
               "New Scenario"

      assert_patch(index_live, ~p"/scenarios/new")

      assert index_live
             |> form("#scenario-form", scenario: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#scenario-form", scenario: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/scenarios")

      html = render(index_live)
      assert html =~ "Scenario created successfully"
      assert html =~ "some description"
    end

    test "updates scenario in listing", %{conn: conn, scenario: scenario} do
      {:ok, index_live, _html} = live(conn, ~p"/scenarios")

      assert index_live |> element("#scenarios-#{scenario.id} a", "Edit") |> render_click() =~
               "Edit Scenario"

      assert_patch(index_live, ~p"/scenarios/#{scenario}/edit")

      assert index_live
             |> form("#scenario-form", scenario: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#scenario-form", scenario: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/scenarios")

      html = render(index_live)
      assert html =~ "Scenario updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes scenario in listing", %{conn: conn, scenario: scenario} do
      {:ok, index_live, _html} = live(conn, ~p"/scenarios")

      assert index_live |> element("#scenarios-#{scenario.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#scenarios-#{scenario.id}")
    end
  end

  describe "Show" do
    setup [:create_scenario]

    test "displays scenario", %{conn: conn, scenario: scenario} do
      {:ok, _show_live, html} = live(conn, ~p"/scenarios/#{scenario}")

      assert html =~ "Show Scenario"
      assert html =~ scenario.description
    end

    test "updates scenario within modal", %{conn: conn, scenario: scenario} do
      {:ok, show_live, _html} = live(conn, ~p"/scenarios/#{scenario}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Scenario"

      assert_patch(show_live, ~p"/scenarios/#{scenario}/show/edit")

      assert show_live
             |> form("#scenario-form", scenario: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#scenario-form", scenario: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/scenarios/#{scenario}")

      html = render(show_live)
      assert html =~ "Scenario updated successfully"
      assert html =~ "some updated description"
    end
  end
end
