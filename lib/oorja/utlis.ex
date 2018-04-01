defmodule Oorja.Utils do
  def unpack_session(session) do
    [user_id, session_id] = String.split(session, ":")
    %{ user_id: user_id, session_id: session_id  }
  end

  def pack_session(user_id, session_id) do
    "#{user_id}:#{session_id}"
  end

  def get_api_secret do
    %{ secret: secret } = Application.get_env(:oorja_beam, :oorja)
    secret
  end
end
