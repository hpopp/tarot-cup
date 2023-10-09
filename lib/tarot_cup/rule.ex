defmodule TarotCup.Rule do
  defstruct id: nil, description: nil

  @all_rules "#{:code.priv_dir(:tarot_cup)}/rules.json"
             |> File.read!()
             |> Jason.decode!()

  def all, do: @all_rules

  def all_ids, do: Enum.map(all(), & &1["id"])

  def get(id) do
    Enum.find(all(), &(&1["id"] == id))
  end
end
