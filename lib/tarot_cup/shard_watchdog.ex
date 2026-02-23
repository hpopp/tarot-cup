defmodule TarotCup.ShardWatchdog do
  @moduledoc """
  Reconnects lost Nostrum shards with backoff.

  When Discord drops the websocket (e.g. heartbeat ack timeout), Nostrum's
  `Session` gen_statem transitions to `connecting_http` to re-establish the
  connection. If the network is temporarily unavailable, each attempt crashes
  with `connect_http_timeout` after 5 seconds. The per-shard `Nostrum.Shard`
  supervisor allows 3 restarts in 60 seconds — exhausted in ~17 seconds of
  rapid retry-crash cycles.

  Critically, `Nostrum.Shard` uses `restart: :transient`, so when the
  supervisor exits with `{:shutdown, :reached_max_restart_intensity}`, the
  parent `DynamicSupervisor` treats it as a normal exit and does not restart
  the shard. The bot is permanently disconnected until the process is
  restarted externally.

  To fix, we poll `Nostrum.Shard.Supervisor` every 30 seconds. When zero active
  shards are detected, we attempt to reconnect using Oban-style polynomial backoff
  (`attempt^4 + 15 + rand(30) * attempt` seconds), capped at `max_attempts`
  (default 20, ~2 weeks of cumulative wait). After reaching the cap, we continue
  retrying at the maximum interval indefinitely.
  """

  use GenServer
  require Logger

  defstruct check_interval: :timer.seconds(30),
            consecutive_failures: 0,
            max_attempts: 20

  @type t :: %__MODULE__{
          check_interval: pos_integer(),
          consecutive_failures: non_neg_integer(),
          max_attempts: pos_integer()
        }

  @spec start_link(keyword()) :: GenServer.on_start()
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    state = struct!(__MODULE__, opts)
    schedule_check(state)
    {:ok, state}
  end

  @impl true
  def handle_info(:check_shards, state) do
    state = check_and_recover(state)
    schedule_check(state)
    {:noreply, state}
  end

  @spec check_and_recover(t()) :: t()
  defp check_and_recover(state) do
    case DynamicSupervisor.count_children(Nostrum.Shard.Supervisor) do
      %{active: 0} ->
        Logger.warning("Shard watchdog: no active shards detected, attempting reconnect")
        attempt_reconnect(state)

      %{active: count} ->
        if state.consecutive_failures > 0 do
          Logger.info(
            "Shard watchdog: #{count} shard(s) active, recovered after " <>
              "#{state.consecutive_failures} failed attempt(s)"
          )
        end

        %{state | consecutive_failures: 0}
    end
  end

  @spec attempt_reconnect(t()) :: t()
  defp attempt_reconnect(state) do
    attempt = min(state.consecutive_failures + 1, state.max_attempts)
    backoff = backoff_seconds(attempt)

    Logger.info("Shard watchdog: backing off #{backoff}s before reconnect (attempt #{attempt})")

    Process.sleep(:timer.seconds(backoff))

    {_url, total_shards} = Nostrum.Util.gateway()

    case Nostrum.Shard.Supervisor.connect(0, total_shards) do
      {:ok, _pid} ->
        Logger.info("Shard watchdog: successfully reconnected shard 0")
        %{state | consecutive_failures: 0}

      {:error, reason} ->
        Logger.error("Shard watchdog: reconnect failed: #{inspect(reason)}")
        %{state | consecutive_failures: attempt}
    end
  end

  # Oban-style polynomial backoff with jitter. Ramps up aggressively:
  # ~46s at attempt 1, ~13min at attempt 5, ~2.9h at attempt 10, ~1.9d at attempt 20.
  @spec backoff_seconds(pos_integer()) :: pos_integer()
  defp backoff_seconds(attempt) do
    Integer.pow(attempt, 4) + 15 + :rand.uniform(30) * attempt
  end

  @spec schedule_check(t()) :: reference()
  defp schedule_check(state) do
    Process.send_after(self(), :check_shards, state.check_interval)
  end
end
