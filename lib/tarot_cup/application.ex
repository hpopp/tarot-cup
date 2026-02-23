defmodule TarotCup.Application do
  @moduledoc false

  use Application

  alias TarotCup.{
    Consumer,
    GameCleaner,
    ShardWatchdog
  }

  @impl true
  @spec start(Application.start_type(), start_args :: term()) ::
          {:ok, pid()} | {:ok, pid(), Application.state()} | {:error, reason :: term()}
  def start(_type, _args) do
    :games = PersistentEts.new(:games, games_data_path(), [:named_table, :public])
    opts = [strategy: :one_for_one, name: TarotCup.Supervisor]
    Supervisor.start_link(children(), opts)
  end

  @spec children :: [Supervisor.child_spec()]
  defp children do
    [
      Consumer,
      GameCleaner,
      ShardWatchdog
    ]
  end

  @spec games_data_path :: String.t()
  defp games_data_path do
    Path.join([Application.get_env(:tarot_cup, :datadir, ""), "games.tab"])
  end
end
