defmodule CoreBanking.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {DynamicSupervisor, name: CoreBanking.AccountSupervisor, strategy: :one_for_one},
      {DynamicSupervisor, name: CoreBanking.BalanceSupervisor, strategy: :one_for_one},
      CoreBanking.Repo
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CoreBanking.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
