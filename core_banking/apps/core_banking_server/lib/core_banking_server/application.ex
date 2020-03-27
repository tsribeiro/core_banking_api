defmodule CoreBankingServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: CoreBankingServer.Server,
        protocol_options: [idle_timeout: 60_000_000, inactivity_timeout: 60_000_000, linger_timeout: 60_000_000],
        options: [port: 8080, transport_options: [num_acceptors: 1000]]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CoreBankingServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
