defmodule FancyLightsUi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FancyLightsUiWeb.Telemetry,
      # Start the PubSub system - prehaps in firmware tree?

      # Start the Endpoint (http/https)
      FancyLightsUiWeb.Endpoint
      # Start a worker by calling: FancyLightsUi.Worker.start_link(arg)
      # {FancyLightsUi.Worker, arg}
    ] ++ children(target())

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FancyLightsUi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def children(:host) do
    [
      {Phoenix.PubSub, name: FancyLights.PubSub},
      FancyLightsUi.Mock
    ]
  end

  def children(_target) do
    []
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FancyLightsUiWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def target() do
    Application.get_env(:fancy_lights_firmware, :target, :host)
  end
end
