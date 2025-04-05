defmodule CocArchivist.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CocArchivistWeb.Telemetry,
      CocArchivist.Repo,
      {DNSCluster, query: Application.get_env(:coc_archivist, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CocArchivist.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: CocArchivist.Finch},
      # Start a worker by calling: CocArchivist.Worker.start_link(arg)
      # {CocArchivist.Worker, arg},
      # Start to serve requests, typically the last entry
      CocArchivistWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CocArchivist.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CocArchivistWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
