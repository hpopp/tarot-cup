defmodule TarotCup.Command.Game do
  use Alchemy.Cogs
  import Alchemy.Embed

  alias Alchemy.{
    Client,
    Embed
  }

  alias TarotCup.{
    GameServer,
    GameServerSupervisor
  }

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
    GameServer.stop(message.channel_id)
    Cogs.say("A new deck is ready.")
  end

  Cogs.def status do
    channel_id = message.channel_id
    GameServerSupervisor.start_server(channel_id)

    channel_id
    |> GameServer.info()
    |> game_embed()
    |> Embed.send()
  end

  Cogs.def draw do
    channel_id = message.channel_id
    GameServerSupervisor.start_server(channel_id)

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

        card
        |> card_embed(message.author.username)
        |> Embed.send("", file: image_path(card))

      {:error, :finished} ->
        Cogs.say("Game is already over, !reset to start a new game.")
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
    @yellow_embed
    |> title(card["name"])
    |> description(card["description"])
    |> field("Arcana", String.capitalize(card["arcana"]), inline: true)
    |> field("Drawer", "@#{author}", inline: true)
    |> image("attachment://#{card["id"]}.jpg")
  end

  def game_embed(game) do
    @yellow_embed
    |> title("Game Information")
    |> field("Cards Played", Enum.count(game.played_cards))
    |> field("Cards Remaining", Enum.count(game.unplayed_cards))
    |> field("Started At", format_dt(game.started_at))
  end

  defp format_dt(dt) do
    Timex.format!(dt, "{Mshort} {D}, {YYYY} :: {h24}:{m}:{s} UTC")
  end
end
