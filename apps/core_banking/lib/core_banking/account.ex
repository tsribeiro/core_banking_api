defmodule CoreBanking.Account do
  use GenServer, restart: :temporary

  require Logger

  def start_link(opts) do
    account = GenServer.start_link(__MODULE__, opts)
    Logger.info("[Init Account] -> #{inspect(account)}")
    account
  end

  # Callbacks

  @impl true
  def init(opts) do
    account_id = Keyword.fetch!(opts, :account_id)
    {:ok, balance} = CoreBanking.Balance.start_link(account_id: account_id)
    {:ok, {account_id, balance}}
  end

  @impl true
  def handle_call({:deposit, amount}, _from, state) do
    {_account_id, balance} = state
    {:reply, CoreBanking.Balance.deposit(balance, amount), state}
  end

  @impl true
  def handle_call({:withdraw, amount}, _from, state) do
    {_account_id, balance} = state
    {:reply, CoreBanking.Balance.withdraw(balance, amount), state}
  end

  @impl true
  def handle_call({:balance}, _from, state) do
    {_account_id, balance} = state
    {:reply, CoreBanking.Balance.get(balance), state}
  end

  def deposit(account, amount) do
    GenServer.call(account, {:deposit, amount})
  end

  def withdraw(account, amount) do
    GenServer.call(account, {:withdraw, amount})
  end

  def balance(account) do
    GenServer.call(account, {:balance})
  end
end
