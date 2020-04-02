import Config

config :tarot_cup,
  discord_token: System.fetch_env!("DISCORD_TOKEN")

# Optional

config :tarot_cup,
  datadir: System.get_env("DATADIR", ""),
  local_images?: System.get_env("LOCAL_IMAGES")
