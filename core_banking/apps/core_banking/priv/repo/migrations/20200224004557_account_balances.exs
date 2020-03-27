defmodule CoreBanking.Repo.Migrations.AccountBalances do
  use Ecto.Migration

  def change do
    create table(:account_balances, primary_key: false) do
      add(:account_balances_id, :serial, primary_key: true)
      add(:kind, :string, null: false)
      add(:account_id, :integer, null: false)
      add(:amount, :integer, default: 0)
      add(:create_at, :naive_datetime, null: false, default: fragment("now()"))
    end

    create(
      constraint("account_balances", "kind_must_be_cash_in_or_cash_out",
        check: "kind in ('cash_in','cash_out')"
      )
    )
  end
end
