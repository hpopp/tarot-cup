defmodule TarotCup.GameTest do
  use ExUnit.Case

  alias TarotCup.{
    Card,
    Game
  }

  test "new/0 initialized with an id and shuffled deck" do
    game = Game.new()

    assert game.id
    assert game.started_at
    refute Enum.empty?(game.unplayed_cards)
  end

  describe "draw/1" do
    test "moves top most unplayed card to played cards" do
      game = Game.new()
      {:ok, _card, updated_game} = Game.draw(game)

      assert Enum.count(updated_game.played_cards) == 1
      assert Enum.count(updated_game.unplayed_cards) == Enum.count(game.unplayed_cards) - 1
    end

    test "marks game as finished if no more unplayed cards" do
      [card] = Enum.take_random(Card.all_ids(), 1)

      game =
        Game.new()
        |> Map.put(:unplayed_cards, [card])

      {:ok, _card, game} = Game.draw(game)
      assert Game.draw(game) == {:error, :finished}
    end

    test "runs through an entire game correctly" do
      game = Game.new()

      game =
        Enum.reduce(1..Enum.count(game.unplayed_cards), game, fn _x, acc ->
          acc |> Game.draw() |> elem(2)
        end)

      assert Game.draw(game) == {:error, :finished}
    end
  end
end
