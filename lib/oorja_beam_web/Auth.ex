defmodule API.Auth do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    [ secret ] = get_req_header(conn, "secret")
    if Oorja.Client.get_api_secret() === secret do
      conn
    else
      conn
      |> send_resp(401, "")
      |> halt()
    end
  end
end
