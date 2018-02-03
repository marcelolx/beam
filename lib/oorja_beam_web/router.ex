defmodule OorjaBeamWeb.Router do
  use OorjaBeamWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", OorjaBeamWeb do
    pipe_through :api
  end
end
