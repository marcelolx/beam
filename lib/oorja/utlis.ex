defmodule Oorja.Utils do
  def unpack_session(session) do
    [user_id, session_id] = String.split(session, ":")
    %{ user_id: user_id, session_id: session_id  }
  end

  def pack_session(user_id, session_id) do
    "#{user_id}:#{session_id}"
  end
end
