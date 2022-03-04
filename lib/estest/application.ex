defmodule Estest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Estest.Repo,
      Estest.ProductsRepo,
      # Start the Telemetry supervisor
      EstestWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Estest.PubSub},
      # Start the Endpoint (http/https)
      EstestWeb.Endpoint,
      # Start a worker by calling: Estest.Worker.start_link(arg)
      # {Estest.Worker, arg}
      Estest.ElasticsearchCluster
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Estest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EstestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
