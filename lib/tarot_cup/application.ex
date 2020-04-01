defmodule TarotCup.Application do
  @moduledoc false

  use Application
  alias Alchemy.Client
  alias TarotCup.GameServerSupervisor

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: TarotCup.Supervisor]
    result = Supervisor.start_link(children(), opts)

    if discord_token() do
      use TarotCup.Command.Game
      use TarotCup.Command.Stats
    end

    result
  end

  defp children do
    import Supervisor.Spec

    [
      supervisor(Registry, [:unique, Registry.TarotCup]),
      GameServerSupervisor,
      discord_client(discord_token())
    ]
    |> Enum.filter(& &1)
  end

  defp discord_client(nil), do: nil

  defp discord_client(token) do
    import Supervisor.Spec
    supervisor(Client, [token, []])
  end

  defp discord_token do
    Application.get_env(:tarot_cup, :discord_token)
  end
end
