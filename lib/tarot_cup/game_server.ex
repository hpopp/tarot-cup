defmodule TarotCup.GameServer do
  alias TarotCup.{
    Card,
    Game,
    Rule
  }

  @table :games

  def total do
    @table
    |> :ets.info()
    |> Keyword.get(:size)
  end

  def status(name) do
    case get(name) do
      nil -> {:error, :nogame}
      game -> {:ok, game}
    end
  end

  def reset(name) do
    game = Game.new()
    save(name, game)
    {:ok, game}
  end

  def draw(name) do
    game = get(name) || Game.new()

    case Game.draw(game) do
      {:ok, card, updated_game} ->
        save(name, updated_game)
        {:ok, card}

      {:error, :finished} ->
        {:error, :finished}
    end
  end

  def peek(name, amount) do
    case get(name) do
      nil ->
        {:error, :nogame}

      game ->
        cards =
          game.unplayed_cards
          |> Enum.take(amount)
          |> Enum.map(fn card_id ->
            card = Card.get(card_id)
            Map.put(card, "description", Rule.get(card["rule_id"])["description"])
          end)

        {:ok, cards}
    end
  end

  def save(name, game) do
    game = Game.update_last_activity(game)
    :ets.insert(@table, [{{:game, name}, game}])
  end

  def get(name) do
    case :ets.lookup(@table, {:game, name}) do
      [] -> nil
      [{{:game, _name}, game}] -> game
    end
  end

  def delete(name) do
    :ets.delete(@table, {:game, name})
  end
end
