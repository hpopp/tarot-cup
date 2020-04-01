import Config

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

config :tarot_cup,
  discord_token: System.fetch_env!("DISCORD_TOKEN")
