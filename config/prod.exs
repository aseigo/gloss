use Mix.Config

# Do not print debug messages in production
config :logger, level: :info

# separately.
import_config "prod.secret.exs"
