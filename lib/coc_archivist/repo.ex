defmodule CocArchivist.Repo do
  use Ecto.Repo,
    otp_app: :coc_archivist,
    adapter: Ecto.Adapters.Postgres
end
