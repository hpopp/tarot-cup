defmodule TarotCup.Application do
  @moduledoc false

  use Application

  alias TarotCup.{
    Consumer,
    GameCleaner
  }

  def start(_type, _args) do
    :games = PersistentEts.new(:games, games_data_path(), [:named_table, :public])
    opts = [strategy: :one_for_one, name: TarotCup.Supervisor]
    Supervisor.start_link(children(), opts)
  end

  defp children do
    [
      Consumer,
      GameCleaner
    ]
  end

  defp games_data_path do
    [
      Application.get_env(:tarot_cup, :datadir, ""),
      "games.tab"
    ]
    |> Path.join()
  end
end
