defmodule TarotCup.Game do
  defstruct id: nil,
            unplayed_cards: [],
            played_cards: [],
            started_at: nil,
            last_activity: nil,
            finished?: false

  alias TarotCup.{
    Card,
    Rule
  }

  def new do
    cards = Enum.shuffle(TarotCup.Card.all_ids())

    %__MODULE__{
      id: UUID.uuid4(),
      unplayed_cards: cards,
      started_at: DateTime.utc_now(),
      last_activity: DateTime.utc_now()
    }
  end

  def draw(%{unplayed_cards: []}) do
    {:error, :finished}
  end

  def draw(%{unplayed_cards: u_cards, played_cards: p_cards} = game) do
    [card_id | rest] = u_cards
    card = Card.get(card_id)
    card = Map.put(card, "description", Rule.get(card["rule_id"])["description"])

    {:ok, card,
     %{
       game
       | unplayed_cards: rest,
         played_cards: [card_id | p_cards],
         finished?: rest == []
     }}
  end

  def update_last_activity(game) do
    %{game | last_activity: DateTime.utc_now()}
  end
end
