import Config

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :opentelemetry, traces_exporter: :none

import_config("#{Mix.env()}.exs")
