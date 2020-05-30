# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :fancy_lights_ui, FancyLightsUiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Fu8a9f5ZkZbM8O8muMFfEZ5xigWDTrovWlaqS1Rt5zSI3jWyBKWgMqwCsxy8f0sI",
  render_errors: [view: FancyLightsUiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: FancyLights.PubSub,
  live_view: [signing_salt: "WXL2po4R"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
