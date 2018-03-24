defmodule OorjaBeamWeb.RoomChannel do
  use OorjaBeamWeb, :channel
  alias OorjaBeamWeb.Presence

  intercept ["direct_msg"]

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

  def handle_in("new_msg", %{ "broadcast" => true } = message, socket) do
    broadcast_from!(socket, "new_msg", put_sender_label(message, socket))
    {:noreply, socket}
  end

  def handle_in("new_msg", %{ "to" => _recipients } = message, socket) do
    broadcast_from!(socket, "direct_msg", put_sender_label(message, socket))
    {:noreply, socket}
  end

  def handle_out("direct_msg", %{ "to" => recipients } = message, socket) do
    if is_recipient?(recipients, get_address(socket.assigns)) do
      push socket, "new_msg", message
      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  def is_recipient?(recipients, address) do
    Enum.any?(recipients, fn recipient ->
      case recipient do
        %{ "session" => session } -> session === Map.get(address, :session)
        %{ "userId" => user_id } -> user_id === Map.get(address, :user_id)
      end
    end)
  end

  def put_sender_label(message, socket) do
    sender = get_address(socket.assigns)
    Map.put(message, "from", sender)
  end


  def get_address(assigns) do
    Map.take(assigns, [ :user_id, :session ])
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
