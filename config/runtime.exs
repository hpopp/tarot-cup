import Config

if config_env() == :prod do
  config :nostrum,
    token: System.fetch_env!("DISCORD_TOKEN")

  if System.get_env("OTLP_ENDPOINT") do
    config :opentelemetry,
      span_processor: :batch,
      traces_exporter: :otlp

    config :opentelemetry_exporter,
      otlp_protocol: :http_protobuf,
      otlp_endpoint: System.get_env("OTLP_ENDPOINT")
  end

  # Optional

  config :logger, level: String.to_atom(System.get_env("LOG_LEVEL", "info"))

  config :tarot_cup,
    datadir: System.get_env("DATADIR", "")
end
