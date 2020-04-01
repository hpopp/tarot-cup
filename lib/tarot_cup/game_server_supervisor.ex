defmodule TarotCup.GameServerSupervisor do
  use DynamicSupervisor
  alias TarotCup.GameServer

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_server(name) do
    DynamicSupervisor.start_child(__MODULE__, {GameServer, [name: name]})
  end
end
