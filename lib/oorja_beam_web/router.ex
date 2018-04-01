defmodule OorjaBeamWeb.Router do
  use OorjaBeamWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug API.Auth
  end

  scope "/api/v1/", OorjaBeamWeb do
    pipe_through :api
    # TODO: plug auth
    post "/push_room_event", RoomController, :push_room_event
    get "/health", HealthController, :health
  end
end
