import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tarot_cup, TarotCupWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :nostrum,
  token: System.get_env("DISCORD_TOKEN")
