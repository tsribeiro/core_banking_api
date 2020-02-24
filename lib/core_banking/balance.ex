defmodule CoreBanking.Balance do
  require Logger

  use Agent, restart: :temporary

  def start_link(opts) do
    account_id = Keyword.fetch!(opts, :account_id)
    Logger.info("[Balance-AccountId] #{account_id}")

    balance =
      CoreBanking.AccountBalance.filter_by_account_id(account_id)
      |> Enum.map(fn item ->
        %{kind: String.to_atom(item.kind), amount: item.amount}
      end)

    status =
      Agent.start_link(fn ->
        {account_id, balance}
      end)

    Logger.info("[Init Balance] -> #{inspect(status)}")
    status
  end

  def deposit(status, amount) do
    order = %{kind: :cash_in, amount: amount}

    Agent.update(status, fn status ->
      {account_id, balance} = status
      CoreBanking.AccountBalance.create("cash_in", amount, account_id)
      {account_id, List.insert_at(balance, 0, order)}
    end)

    {:ok, order}
  end

  def withdraw(status, amount) do
    cond do
      get(status) >= amount ->
        order = %{kind: :cash_out, amount: amount}

        Agent.update(status, fn status ->
          {account_id, balance} = status
          CoreBanking.AccountBalance.create("cash_out", amount, account_id)
          {account_id, List.insert_at(balance, 0, order)}
        end)

        {:ok, order}

      true ->
        {:error, %{code: :insufficient_funds}}
    end
  end

  def get(status) do
    Agent.get(
      status,
      fn status ->
        {_account_id, balance} = status

        Enum.reduce(balance, 0, fn order, acc ->
          case order.kind do
            :cash_in -> order.amount + acc
            :cash_out -> acc - order.amount
          end
        end)
      end
    )
  end
end
