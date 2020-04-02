defmodule TarotCup.GameCleaner do
  use GenServer
  alias TarotCup.GameServer
  require Logger

  @table :games
  @interval 1000 * 60 * 30
  @expiration 1000 * 60 * 60 * 6

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    Process.send_after(self(), :run, @interval)
    {:ok, :ok}
  end

  def handle_info(:run, _state) do
    Logger.info("[#{__MODULE__}] Starting clean.")
    clean()
    Logger.info("[#{__MODULE__}] Clean finished.")

    Process.send_after(self(), :run, @interval)

    {:noreply, :ok}
  end

  def clean do
    @table
    |> :ets.first()
    |> clean()
  end

  def clean(:"$end_of_table"), do: :ok

  def clean(key) do
    [{{:game, name}, game}] = :ets.lookup(@table, key)
    next_key = :ets.next(@table, key)

    if expired?(game.last_activity) do
      Logger.info("[#{__MODULE__}] Cleaning #{name}.")
      GameServer.delete(name)
    end

    clean(next_key)
  end

  def expired?(game) do
    ago = DateTime.add(DateTime.utc_now(), -@expiration, :millisecond)

    case DateTime.compare(game, ago) do
      :lt -> true
      _ -> false
    end
  end
end
