defmodule OorjaBeamWeb.RoomController do
  use OorjaBeamWeb, :controller

  def push_room_event(conn, params) do
    IO.inspect params
    channel = "room:#{params["room_id"]}"
    event = params["event"]
    payload = params["payload"]

    OorjaBeamWeb.Endpoint.broadcast(channel, event, payload)
    send_resp(conn, 200, "")
  end
end
