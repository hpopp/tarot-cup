defmodule TarotCup.Handler.Game do
  alias Nostrum.Api
  alias Nostrum.Struct.Embed
  alias TarotCup.GameServer
  require Logger

  @yellow 0xF7DC54

  def handle_draw(interaction) do
    interaction.channel_id
    |> GameServer.draw()
    |> case do
      {:ok, card} ->
        case card do
          %{"id" => "16-tower"} ->
            cards =
              interaction.channel_id
              |> GameServer.peek(3)
              |> elem(1)
              |> Enum.map(& &1["name"])
              |> Enum.join(", ")

            {:ok, chan} = Api.create_dm(interaction.user.id)
            Api.create_message(chan.id, cards)

          _else ->
            :ok
        end

        embed = card_embed(card, interaction.user.id)
        file = image_path(card)

        response = %{type: 4, data: %{file: file, embeds: [embed]}}
        Api.create_interaction_response(interaction, response)

      {:error, :finished} ->
        msg = "Game is already over, !reset to start a new game."
        response = %{type: 4, data: %{content: msg}}
        Api.create_interaction_response(interaction, response)
    end
  end

  def handle_bet(interaction, count) do
    [result] =
      Enum.take_random(
        [
          "Congrats! Everyone else drinks #{count}.",
          "Ooof, you gotta drink #{count}."
        ],
        1
      )

    response = %{type: 4, data: %{content: result}}
    Api.create_interaction_response(interaction, response)
  end

  def handle_reset(interaction) do
    GameServer.reset(interaction.channel_id)

    response = %{type: 4, data: %{content: "A new deck is ready."}}
    Api.create_interaction_response(interaction, response)
  end

  def handle_status(interaction) do
    response =
      interaction.channel_id
      |> GameServer.status()
      |> case do
        {:ok, game} -> %{type: 4, data: %{embeds: [game_embed(game)]}}
        {:error, :nogame} -> %{type: 4, data: %{content: "No active game. /draw to start one."}}
      end

    Api.create_interaction_response(interaction, response)
  end

  defp card_embed(card, author) do
    %Embed{}
    |> Embed.put_title(card["name"])
    |> Embed.put_description(card["description"])
    |> Embed.put_color(@yellow)
    |> Embed.put_field("Arcana", String.capitalize(card["arcana"]), true)
    |> Embed.put_field("Drawer", "<@#{author}>", true)
  end

  def game_embed(game) do
    %Embed{}
    |> Embed.put_title("Game Information")
    |> Embed.put_color(@yellow)
    |> Embed.put_field("Cards Played", Enum.count(game.played_cards))
    |> Embed.put_field("Cards Remaining", Enum.count(game.unplayed_cards))
    |> Embed.put_field("Started At", format_dt(game.started_at))
    |> Embed.put_field("Last Activity", format_dt(game.last_activity))
  end

  defp local_images? do
    Application.get_env(:tarot_cup, :local_images?, false)
  end

  defp format_dt(dt) do
    Timex.format!(dt, "{Mshort} {D}, {YYYY} :: {h24}:{m}:{s} UTC")
  end

  defp image_path(%{"id" => card_id}) do
    Path.join([
      :code.priv_dir(:tarot_cup),
      "img",
      "#{card_id}.jpg"
    ])
  end
end
