defmodule CoreBankingServer.Account do
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  def response(conn, code_http, entity) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(code_http, Jason.encode!(entity))
  end

  post "/:id/balance/deposit" do
    {:ok} = CoreBanking.AccountRegistry.create(CoreBanking.AccountRegistry, id)
    {:ok, account} = CoreBanking.AccountRegistry.get(CoreBanking.AccountRegistry, id)
    {:ok, ret} = CoreBanking.Account.deposit(account, conn.body_params["amount"])

     Agent.stop( CoreBanking.Account.get_balance(account), :shutdown)

    response(conn, 201, ret)
  end

  post "/:id/balance/withdraw" do
    {:ok} = CoreBanking.AccountRegistry.create(CoreBanking.AccountRegistry, id)
    {:ok, account} = CoreBanking.AccountRegistry.get(CoreBanking.AccountRegistry, id)
    {:ok, ret} = CoreBanking.Account.withdraw(account, conn.body_params["amount"])

    Agent.stop( CoreBanking.Account.get_balance(account), :shutdown)

    response(conn, 201, ret)
  end

  get "/:id/balance" do
    {:ok} = CoreBanking.AccountRegistry.create(CoreBanking.AccountRegistry, id)
    {:ok, account} = CoreBanking.AccountRegistry.get(CoreBanking.AccountRegistry, id)
    ret = %{balance: CoreBanking.Account.balance(account)}

    Agent.stop( CoreBanking.Account.get_balance(account), :shutdown)

    response(conn, 200, ret)
  end
end
