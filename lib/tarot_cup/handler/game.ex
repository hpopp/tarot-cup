defmodule TarotCup.Handler.Game do
  alias Nostrum.Api
  alias Nostrum.Struct.Embed
  alias TarotCup.GameServer
  require Logger

  @yellow 0xF7DC54

  def handle_draw(msg) do
    msg.channel_id
    |> GameServer.draw()
    |> case do
      {:ok, card} ->
        case card do
          %{"id" => "16-tower"} ->
            cards =
              msg.channel_id
              |> GameServer.peek(3)
              |> elem(1)
              |> Enum.map(& &1["name"])
              |> Enum.join(", ")

            {:ok, chan} = Api.create_dm(msg.author.id)
            Api.create_message(chan.id, cards)

          _else ->
            :ok
        end

        embed = card_embed(card, msg.author.username)

        if local_images?() do
          file = image_path(card)
          Api.create_message(msg.channel_id, file: file)
        else
          embed = Embed.put_image(embed, card["image_url"])
          Api.create_message(msg.channel_id, embed: embed)
        end

      {:error, :finished} ->
        Api.create_message(msg.channel_id, "Game is already over, !reset to start a new game.")
    end
  end

  def handle_bet(channel_id, count) do
    [result] = Enum.take_random([true, false], 1)

    if result do
      Api.create_message(channel_id, "Congrats! Everyone else drinks #{count}.")
    else
      Api.create_message(channel_id, "Ooof, you gotta drink #{count}.")
    end
  end

  def handle_reset(channel_id) do
    GameServer.reset(channel_id)
    Api.create_message(channel_id, "A new deck is ready.")
  end

  def handle_status(channel_id) do
    channel_id
    |> GameServer.status()
    |> case do
      {:ok, game} -> Api.create_message(channel_id, embed: game_embed(game))
      {:error, :nogame} -> Api.create_message(channel_id, "No active game. !draw to start one.")
    end
  end

  defp card_embed(card, author) do
    %Embed{}
    |> Embed.put_title(card["name"])
    |> Embed.put_description(card["description"])
    |> Embed.put_color(@yellow)
    |> Embed.put_field("Arcana", String.capitalize(card["arcana"]), true)
    |> Embed.put_field("Drawer", "@#{author}", true)
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
