defmodule OorjaBeamWeb.RoomChannel do
  use OorjaBeamWeb, :channel
  alias OorjaBeamWeb.Presence

  def join("room:" <> room_id, %{ "room_token" => room_token, "session" => session }, socket) do
    if authorized?(room_id, room_token) do
      send(self(), :after_join)
      %{ session_id: session_id } = Oorja.Utils.unpack_session(session)
      {:ok, assign(socket, :session_id, session_id)}
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
    %{ user_id: user_id, session_id: session_id } = socket.assigns
    {:ok, _} = Presence.track(socket, "#{user_id}:#{session_id}", %{
      online_at: inspect(System.system_time(:seconds))
    })
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  defp authorized?(room_id, room_token) do
    case Oorja.Client.decode_token("room", room_token) do
      %{ "room_id" => token_room_id } -> token_room_id === room_id
      _ -> false
    end
  end
end
