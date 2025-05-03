import Config

if config_env() == :prod do
  config :nostrum,
    token: System.fetch_env!("DISCORD_TOKEN")

  case System.get_env("GCP_PROJECT_ID") do
    nil ->
      :ok

    project_id ->
      version = :tarot_cup |> Application.spec() |> Keyword.get(:vsn) |> to_string()

      opts = [
        metadata: :all,
        project_id: project_id,
        service_context: %{
          service: "tarot-cup",
          version: version
        }
      ]

      config :logger, :default_handler, formatter: LoggerJSON.Formatters.GoogleCloud.new(opts)
  end

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
