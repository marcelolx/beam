defmodule OorjaBeamWeb.RoomChannel do
  use OorjaBeamWeb, :channel
  alias OorjaBeamWeb.Presence

  def join("room:" <> room_id, %{ "room_token" => room_token, "session_id" => session_id }, socket) do
    if authorized?(room_id, room_token) do
      send(self(), :after_join)
      %{ user_id: user_id} = socket.assigns
      socket = assign(socket, :room_id, room_id)
      socket = assign(socket, :session, Oorja.Utils.pack_session(user_id ,session_id))
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)
    %{ session: session } = socket.assigns
    {:ok, _} = Presence.track(socket, session, %{
      online_at: inspect(System.system_time(:seconds))
    })
    {:noreply, socket}
  end

  defp authorized?(room_id, room_token) do
    case Oorja.Client.decode_token("room", room_token) do
      %{ "room_id" => token_room_id } -> token_room_id === room_id
      _ -> false
    end
  end
end
