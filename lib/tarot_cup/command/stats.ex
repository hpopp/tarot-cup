defmodule TarotCup.Command.Stats do
  use Alchemy.Cogs
  alias Alchemy.Embed
  alias TarotCup.GameServer
  import Embed

  @title "Tarot Cup"
  @description "King's Cup, revised. A drinking game."
  @yellow_embed %Embed{color: 0xF7DC54}

  Cogs.def help do
    info = [
      {"**!draw**", "Draw a card from the deck."},
      {"**!reset**", "Reset the game to a fresh deck."},
      {"**!status**", "Check the number of cards remaining in the deck."},
      {"**!bet n**", "Bet n number of drinks. Used in certain cards."},
      {"**!info**", "Get information about this bot."}
    ]

    Enum.reduce(info, @yellow_embed, fn {name, value}, embed ->
      field(embed, name, value)
    end)
    |> title(@title)
    |> description("""
    #{@description}

    **Available commands:**
    """)
    |> Embed.send()
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
  end

  Cogs.def info do
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

    info
    |> Enum.reduce(@yellow_embed, fn {name, value}, embed ->
      field(embed, name, value, inline: true)
    end)
    |> title(@title)
    |> description(@description)
    |> url("https://github.com/hpopp/tarot-cup")
    |> Embed.send()
  end

  Cogs.def sysinfo do
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

    Enum.reduce(info, @yellow_embed, fn {name, value}, embed ->
      field(embed, name, value, inline: true)
    end)
    |> Embed.send()
  end
end
