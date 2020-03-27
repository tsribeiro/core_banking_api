defmodule CoreBanking.Repo do
  use Ecto.Repo,
    otp_app: :core_banking,
    adapter: Ecto.Adapters.Postgres
end
