defmodule CoreBankingServer.Server do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(CORSPlug, origin: "*")
  plug(:dispatch)

  forward("/accounts", to: CoreBankingServer.Account)

  get "/" do
    send_resp(conn, 200, "ok")
  end

  match _ do
    send_resp(conn, 404, "Not Found Resource")
  end
end
