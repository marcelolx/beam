defmodule Oorja.Client do
  use HTTPotion.Base

  def decode_token(token) do
    # The point of jwt was to pass on claims that can be verified independenly
    # by authorized parties. I don't want to make an http call to decode a token
    # but for some reason any of the elixir libraries I used could not successfully
    # decode tokens issued by oorja. Maybe I'm missing somthing idk, should revisit this.
    %{ token: token}
      |>Poison.encode!
      |>(&(post("/api/v1/private/jwt_decode", [ body: &1 ]).body)).()
      |>Map.get("data")
  end

  # Internal #########

  def process_url(path) do
    %{ host: host } = Application.get_env(:oorja_beam, :oorja)
    host <> path
  end

  def process_request_headers(headers) do
    %{ secret: secret } = Application.get_env(:oorja_beam, :oorja)
    Keyword.merge headers, [ "Content-Type": "application/json", "oorja-secret": secret ]
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end
end