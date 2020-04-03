defmodule TarotCup.Consumer do
  use Nostrum.Consumer

  alias TarotCup.Handler.{
    Game,
    Stats
  }

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "!bet " <> count -> Game.handle_bet(msg.channel_id, count)
      "!draw" -> Game.handle_draw(msg)
      "!reset" -> Game.handle_reset(msg.channel_id)
      "!status" -> Game.handle_status(msg.channel_id)
      "!help" -> Stats.handle_help(msg.channel_id)
      "!info" -> Stats.handle_project_info(msg.channel_id)
      "!sysinfo" -> Stats.handle_sysinfo(msg.channel_id)
      _other -> :ignore
    end
  end

  def handle_event(_event) do
    :noop
  end
end
