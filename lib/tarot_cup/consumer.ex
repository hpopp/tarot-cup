defmodule TarotCup.Consumer do
  use Nostrum.Consumer

  alias TarotCup.Handler.{
    Game,
    Stats
  }

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, _msg, _ws_state}) do
    register_commands()
    :ignore
  end

  def handle_event({:INTERACTION_CREATE, %{data: %{name: "bet"}} = msg, _ws_state}) do
    [%{value: count}] = msg.data.options
    Game.handle_bet(msg, count)
  end

  def handle_event({:INTERACTION_CREATE, %{data: %{name: "draw"}} = msg, _ws_state}) do
    Game.handle_draw(msg)
  end

  def handle_event({:INTERACTION_CREATE, %{data: %{name: "help"}} = msg, _ws_state}) do
    Stats.handle_help(msg)
  end

  def handle_event({:INTERACTION_CREATE, %{data: %{name: "info"}} = msg, _ws_state}) do
    Stats.handle_project_info(msg)
  end

  def handle_event({:INTERACTION_CREATE, %{data: %{name: "reset"}} = msg, _ws_state}) do
    Game.handle_reset(msg)
  end

  def handle_event({:INTERACTION_CREATE, %{data: %{name: "status"}} = msg, _ws_state}) do
    Game.handle_status(msg)
  end

  def handle_event({:INTERACTION_CREATE, %{data: %{name: "sysinfo"}} = msg, _ws_state}) do
    Stats.handle_sysinfo(msg)
  end

  def handle_event(_event) do
    :noop
  end

  defp register_commands do
    commands = [
      %{
        name: "bet",
        description: "Bet n number of drinks. Used in certain cards.",
        options: [
          %{
            type: 3,
            name: "drinks",
            description: "Number of drinks to bet",
            required: true
          }
        ]
      },
      %{
        name: "draw",
        type: 1,
        description: "Draw a card from the deck."
      },
      %{
        name: "help",
        type: 1,
        description: "Displays all commands of this bot."
      },
      %{
        name: "info",
        type: 1,
        description: "Get information about this bot."
      },
      %{
        name: "reset",
        type: 1,
        description: "Reset the game to a fresh deck."
      },
      %{
        name: "status",
        type: 1,
        description: "Check the number of cards remaining in the deck."
      },
      %{
        name: "sysinfo",
        type: 1,
        description: "Get system info about this bot."
      }
    ]

    for command <- commands do
      Nostrum.Api.create_global_application_command(command)
    end
  end
end
