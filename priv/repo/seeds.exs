# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CocArchivist.Repo.insert!(%CocArchivist.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias CocArchivist.Repo
alias CocArchivist.Scenarios.Scenario
alias CocArchivist.Scenarios.Character

Repo.insert!(%Scenario{
  title: "Red Forest",
  description: "Adventure in the spooky Red Forest",
  location: "Red Forest",
  date: "2021-01-01"
})
