defmodule OorjaBeamWeb.HealthController do
  use OorjaBeamWeb, :controller

  def health(conn, _params) do
     conn
     |> send_resp(200, "")
  end
end
