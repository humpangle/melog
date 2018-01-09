# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :melog,
  ecto_repos: [Melog.Repo]

# Configures the endpoint
config :melog, MelogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "krSR9+M9OjeacCkWDTgMMM6ZgxGSG0dTjdu+y94u9lyBisyPmRADyKINkTDAokkO",
  render_errors: [view: MelogWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Melog.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
