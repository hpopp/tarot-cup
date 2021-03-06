defmodule TarotCup.Card do
  defstruct id: nil, name: nil, rule: nil, image_url: nil

  @all_cards "#{:code.priv_dir(:tarot_cup)}/cards.json"
             |> File.read!()
             |> Poison.decode!()

  def all, do: @all_cards

  def all_ids, do: Enum.map(all(), & &1["id"])

  def get(card_id) do
    Enum.find(all(), &(&1["id"] == card_id))
  end
end
