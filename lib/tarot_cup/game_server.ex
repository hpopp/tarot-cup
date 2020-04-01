defmodule TarotCup.GameServer do
  use GenServer, restart: :transient

  alias TarotCup.{
    Card,
    Game,
    Rule
  }

  def start_link(opts \\ []) do
    name = Keyword.get(opts, :name)
    GenServer.start_link(__MODULE__, :ok, name: via_tuple(name))
  end

  def init(:ok) do
    game = Game.new()
    {:ok, game}
  end

  def info(name) do
    name
    |> via_tuple()
    |> GenServer.call(:info)
  end

  def draw(name) do
    name
    |> via_tuple()
    |> GenServer.call(:draw)
  end

  def peek(name, amount) do
    name
    |> via_tuple()
    |> GenServer.call({:peek, amount})
  end

  def stop(name) do
    name
    |> via_tuple()
    |> GenServer.cast(:stop)
  end

  def handle_call(:info, _from, game) do
    {:reply, game, game}
  end

  def handle_call(:draw, _from, game) do
    case Game.draw(game) do
      {:ok, card, updated_game} ->
        {:reply, {:ok, card}, updated_game}

      {:error, :finished} ->
        {:reply, {:error, :finished}, game}
    end
  end

  def handle_call({:peek, amount}, _from, game) do
    cards =
      game.unplayed_cards
      |> Enum.take(amount)
      |> Enum.map(fn card_id ->
        card = Card.get(card_id)
        Map.put(card, "description", Rule.get(card["rule_id"])["description"])
      end)

    {:reply, {:ok, cards}, game}
  end

  def handle_cast(:stop, game) do
    {:stop, :normal, game}
  end

  def via_tuple(name) do
    {:via, Registry, {Registry.TarotCup, name}}
  end
end
