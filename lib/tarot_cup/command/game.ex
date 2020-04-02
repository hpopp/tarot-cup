defmodule TarotCup.Command.Game do
  use Alchemy.Cogs
  import Alchemy.Embed

  alias Alchemy.{
    Client,
    Embed
  }

  alias TarotCup.GameServer

  require Logger

  @yellow_embed %Embed{color: 0xF7DC54}

  @doc """
  The classic ping command, including the latency.
  """
  Cogs.def ping do
    message |> inspect() |> Logger.info()
    Cogs.say("pong! Channel: #{message.channel_id}")
  end

  Cogs.def reset do
    GameServer.reset(message.channel_id)
    Cogs.say("A new deck is ready.")
  end

  Cogs.def status do
    message.channel_id
    |> GameServer.status()
    |> case do
      {:ok, game} ->
        game
        |> game_embed()
        |> Embed.send()

      {:error, :nogame} ->
        Cogs.say("No active game. !draw to start one.")
    end
  end

  Cogs.def draw do
    channel_id = message.channel_id

    channel_id
    |> GameServer.draw()
    |> case do
      {:ok, card} ->
        case card do
          %{"id" => "16-tower"} ->
            cards =
              channel_id
              |> GameServer.peek(3)
              |> elem(1)
              |> Enum.map(& &1["name"])
              |> Enum.join(", ")

            {:ok, chan} = Client.create_DM(message.author.id)
            Client.send_message(chan.id, cards)

          _else ->
            :ok
        end

        embed = card_embed(card, message.author.username)

        if local_images?() do
          Embed.send(embed, "", file: image_path(card))
        else
          Embed.send(embed)
        end

      {:error, :finished} ->
        Cogs.say("Game is already over, !draw to start a new game.")
    end
  end

  defp image_path(%{"id" => card_id}) do
    Path.join([
      :code.priv_dir(:tarot_cup),
      "img",
      "#{card_id}.jpg"
    ])
  end

  Cogs.def bet(count) do
    [result] = Enum.take_random([true, false], 1)

    if result do
      Cogs.say("Congrats! Everyone else drinks #{count}.")
    else
      Cogs.say("Ooof, you gotta drink #{count}.")
    end
  end

  def card_embed(card, author) do
    embed =
      @yellow_embed
      |> title(card["name"])
      |> description(card["description"])
      |> field("Arcana", String.capitalize(card["arcana"]), inline: true)
      |> field("Drawer", "@#{author}", inline: true)

    if local_images?() do
      image(embed, "attachment://#{card["id"]}.jpg")
    else
      image(embed, "#{card["image_url"]}")
    end
  end

  def game_embed(game) do
    @yellow_embed
    |> title("Game Information")
    |> field("Cards Played", Enum.count(game.played_cards))
    |> field("Cards Remaining", Enum.count(game.unplayed_cards))
    |> field("Started At", format_dt(game.started_at))
    |> field("Last Activity", format_dt(game.last_activity))
  end

  defp local_images?, do: Application.get_env(:tarot_cup, :local_images?, false)

  defp format_dt(dt) do
    Timex.format!(dt, "{Mshort} {D}, {YYYY} :: {h24}:{m}:{s} UTC")
  end
end
