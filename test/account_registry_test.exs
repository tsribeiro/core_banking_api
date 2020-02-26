defmodule CoreBanking.AccountRegistryTest do
  use ExUnit.Case, async: true
  require Ecto.Query

  setup do
    accounts_id = [Enum.random(0..1000), Enum.random(0..1000)]

    on_exit(fn ->
      Enum.each(
        accounts_id,
        fn account_id ->
          CoreBanking.AccountBalance
          |> Ecto.Query.where(account_id: ^account_id)
          |> CoreBanking.Repo.all()
          |> Enum.each(&CoreBanking.Repo.delete(&1))
        end
      )
    end)

    %{accounts_id: accounts_id}
  end

  test "should create account", %{accounts_id: accounts_id} do
    [first_account, second_account] =
      Enum.reduce(accounts_id, [], fn account_id, acc ->
        CoreBanking.AccountRegistry.create(CoreBanking.AccountRegistry, account_id)
        {:ok, account} = CoreBanking.AccountRegistry.get(CoreBanking.AccountRegistry, account_id)

        [account | acc]
      end)

    CoreBanking.Account.deposit(first_account, 1500)
    CoreBanking.Account.deposit(second_account, 15)

    orders =
      Enum.shuffle([
        %{account: first_account, amount: 1000, kind: :deposit},
        %{account: first_account, amount: 1000, kind: :deposit},
        %{account: first_account, amount: 1000, kind: :withdraw},
        %{account: first_account, amount: 500, kind: :withdraw},
        %{account: second_account, amount: 10, kind: :deposit},
        %{account: second_account, amount: 10, kind: :deposit},
        %{account: second_account, amount: 10, kind: :withdraw},
        %{account: second_account, amount: 5, kind: :withdraw}
      ])

    tasks =
      Enum.reduce(orders, [], fn order, acc ->
        [
          Task.async(fn ->
            case order.kind do
              :deposit ->
                CoreBanking.Account.deposit(order.account, order.amount)

              :withdraw ->
                CoreBanking.Account.withdraw(order.account, order.amount)
            end
          end)
          | acc
        ]
      end)

    Enum.map(tasks, &Task.await/1)

    assert CoreBanking.Account.balance(first_account) == 2000
    assert CoreBanking.Account.balance(second_account) == 20
  end
end
