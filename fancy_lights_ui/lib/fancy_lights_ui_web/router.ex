defmodule FancyLightsUiWeb.Router do
  use FancyLightsUiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Define livedash here as we have a catchall route below
  if Mix.env() in [:dev, :test, :prod] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: FancyLightsUiWeb.Telemetry
    end
  end

  scope "/", FancyLightsUiWeb do
    pipe_through :browser


    delete "/lifecycle", LifecycleController, :delete
    post "/lights/:status", LightController, :new
    post "/lights", LightController, :update
    get "/*path", PageController, :index
  end

end
