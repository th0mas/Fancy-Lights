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

  # Alexa integration, pretend to be a Philips Hue Hub
  # Similar to https://github.com/pborges/huejack/blob/4bd1e5447b881764bfb5ab11a5c3aa4805f00c21/handler.go
  scope "/api", FancyLightsUiWeb do
    pipe_through :api
    get "/:userid", HueEmulatorController, :index
    put "/:userid/lights/:lightid/state", HueEmulatorController, :edit
    get "/:userid/lights/:lightid", HueEmulatorController, :show
  end

  scope "/", FancyLightsUiWeb do
    pipe_through :browser

    delete "/lifecycle", LifecycleController, :delete
    get "/*path", PageController, :index
  end

end
