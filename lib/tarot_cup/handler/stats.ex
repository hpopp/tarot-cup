defmodule TarotCup.Handler.Stats do
  alias Nostrum.Api
  alias Nostrum.Struct.Embed
  alias TarotCup.GameServer
  require Logger

  @title "Tarot Cup"
  @description "King's Cup, revised. A drinking game."
  @yellow 0xF7DC54

  def handle_help(channel_id) do
    info = [
      {"**!draw**", "Draw a card from the deck."},
      {"**!reset**", "Reset the game to a fresh deck."},
      {"**!status**", "Check the number of cards remaining in the deck."},
      {"**!bet n**", "Bet n number of drinks. Used in certain cards."},
      {"**!info**", "Get information about this bot."}
    ]

    embed =
      %Embed{}
      |> Embed.put_title(@title)
      |> Embed.put_description("""
      #{@description}

      **Available commands:**
      """)
      |> Embed.put_color(@yellow)
      |> put_fields(info)

    Api.create_message(channel_id, embed: embed)
  end

  def handle_project_info(channel_id) do
    # Memory is returned in bytes
    memory = div(:erlang.memory(:total), 1_000_000)
    version = to_string(Application.spec(:tarot_cup, :vsn))
    games = GameServer.total()

    info = [
      {"Version", version},
      {"Library", "[Tarot Cup](https://github.com/hpopp/tarot-cup)"},
      {"Author", "hpopp\#5679"},
      {"Uptime", uptime() || "--"},
      {"Active Games", "#{games}"},
      {"Memory Usage", "#{memory} MB"}
    ]

    embed =
      %Embed{}
      |> Embed.put_title(@title)
      |> Embed.put_description(@description)
      |> Embed.put_color(@yellow)
      |> Embed.put_url("https://github.com/hpopp/tarot-cup")
      |> put_fields(info, true)

    Api.create_message(channel_id, embed: embed)
  end

  def handle_sysinfo(channel_id) do
    memories = :erlang.memory()
    processes = length(:erlang.processes())
    {{_, io_input}, {_, io_output}} = :erlang.statistics(:io)

    mem_format = fn
      mem, :kb -> "#{div(mem, 1000)} KB"
      mem, :mb -> "#{div(mem, 1_000_000)} MB"
    end

    info = [
      {"Uptime", uptime()},
      {"Processes", "#{processes}"},
      {"Total Memory", mem_format.(memories[:total], :mb)},
      {"IO Input", mem_format.(io_input, :mb)},
      {"Process Memory", mem_format.(memories[:processes], :mb)},
      {"Code Memory", mem_format.(memories[:code], :mb)},
      {"IO Output", mem_format.(io_output, :mb)},
      {"ETS Memory", mem_format.(memories[:ets], :kb)},
      {"Atom Memory", mem_format.(memories[:atom], :kb)}
    ]

    embed =
      %Embed{}
      |> Embed.put_color(@yellow)
      |> put_fields(info, true)

    Api.create_message(channel_id, embed: embed)
  end

  defp put_fields(embed, fields, inline \\ nil) do
    Enum.reduce(fields, embed, fn {name, value}, embed ->
      Embed.put_field(embed, name, value, inline)
    end)
  end

  # Returns a nicely formatted uptime string
  def uptime do
    {time, _} = :erlang.statistics(:wall_clock)
    min = div(time, 1000 * 60)
    {hours, min} = {div(min, 60), rem(min, 60)}
    {days, hours} = {div(hours, 24), rem(hours, 24)}

    Stream.zip([min, hours, days], ["m", "h", "d"])
    |> Enum.reduce("", fn
      {0, _glyph}, acc -> acc
      {t, glyph}, acc -> " #{t}" <> glyph <> acc
    end)
    |> case do
      "" -> "< 1m"
      val -> val
    end
  end
end
