defmodule CoreBanking.AccountTest do
  use ExUnit.Case, async: true

  setup do
    account_id = Enum.random(0..1000)
    {:ok, account} =
      DynamicSupervisor.start_child(
        CoreBanking.AccountSupervisor,
        {CoreBanking.Account, account_id: account_id}
      )

    on_exit(fn ->
      CoreBanking.AccountBalance.filter_by_account_id(account_id)
      |> Enum.each(&CoreBanking.Repo.delete(&1))
    end)

    %{account: account}
  end

  test "should work correctly", %{account: account} do
    CoreBanking.Account.deposit(account, 1000)
    CoreBanking.Account.deposit(account, 1000)
    CoreBanking.Account.withdraw(account, 1000)

    assert CoreBanking.Account.balance(account) == 1000
  end

  test "must recover from failure correctly", %{account: account} do
    CoreBanking.Account.deposit(account, 1000)
    balance = GenServer.call(account, {:get_balance})

    Agent.stop(balance, :shutdown)

    assert CoreBanking.Account.balance(account) == 1000
  end
end