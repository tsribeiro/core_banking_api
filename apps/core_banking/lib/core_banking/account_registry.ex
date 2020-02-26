defmodule CoreBanking.AccountRegistry do
  use GenServer

  require Logger

  def start_link(opts) do
    account_registry = GenServer.start_link(__MODULE__, :ok, opts)
    Logger.info("[Init AccountRegistry] -> #{inspect(account_registry)}")
    account_registry
  end

  @impl true
  def init(_opts) do
    accounts = %{}
    refs = %{}

    {:ok, {accounts, refs}}
  end

  @impl true
  def handle_call({:get, account_id}, _from, state) do
    {accounts, _} = state
    {:reply, Map.fetch(accounts, account_id), state}
  end

  @impl true
  def handle_call({:create, account_id}, _from, {accounts, refs}) do
    if Map.has_key?(accounts, account_id) do
      {:reply, :ok, {accounts, refs}}
    else
      {:ok, account} =
        DynamicSupervisor.start_child(
          CoreBanking.AccountSupervisor,
          {CoreBanking.Account, account_id: account_id}
        )

      ref = Process.monitor(account)
      refs = Map.put(refs, ref, account_id)
      accounts = Map.put(accounts, account_id, account)
      {:reply, :ok, {accounts, refs}}
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {accounts, refs}) do
    Logger.info "handle_info AccountRegistry"
    {account_id, refs} = Map.pop(refs, ref)
    accounts = Map.delete(accounts, account_id)
    {:noreply, {accounts, refs}}
  end

  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end

  def create(account_registry, account_id) do
    GenServer.call(account_registry, {:create, account_id})
  end

  def get(account_registry, account_id) do
    GenServer.call(account_registry, {:get, account_id})
  end
end
