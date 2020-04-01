import Config

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :porcelain, goon_warn_if_missing: false

import_config("#{Mix.env()}.exs")
