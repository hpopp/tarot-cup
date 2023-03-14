import Config

config :nostrum,
  token: System.fetch_env!("DISCORD_TOKEN")

# Optional

config :logger, level: String.to_atom(System.get_env("LOG_LEVEL", "info"))

config :tarot_cup,
  datadir: System.get_env("DATADIR", ""),
  local_images?: System.get_env("LOCAL_IMAGES")
