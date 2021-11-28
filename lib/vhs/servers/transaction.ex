defmodule Vhs.Servers.Transaction do
  use GenServer

  alias Vhs.Clients.Slack
  alias __MODULE__

  # Client API
  @doc """
  Update the status for the given hash
  """
  def update_status(%{"hash" => hash, "status" => status}) do
    update_status(hash, status)
  end

  def update_status(hash, status) do
    GenServer.cast(Transaction, {:update_status, hash, status})
  end

  @doc """
  Register the hash with state "intiated" or "pending" and gets updated
  from webhook url POST /blocknative/webhook
  """
  def register(hash, status \\ "pending") do
    GenServer.call(Transaction, {:register, hash, status})
  end

  @doc """
  List the all pending transactions where the status is not "confirmed"
  """
  def get_pending_transactions() do
    GenServer.call(Transaction, :pending_transactions)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  # Server API
  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_info({:notify_slack, hash}, state) do
    if state[hash] != "confirmed" do
      notify_slack(hash, state[hash])
    end

    {:noreply, state}
  end

  @impl true
  def handle_call({:register, hash, status}, _from, state) do
    schedule_work(hash)
    state = Map.put(state, hash, status)
    {:reply, {:ok, hash}, state}
  end

  @impl true
  def handle_call(:pending_transactions, _from, state) do
    pending_transactions = Enum.filter(state, &is_pending_transaction/1)

    {:reply, {:ok, pending_transactions}, state}
  end

  @impl true
  def handle_cast({:update_status, hash, status}, state) do
    new_state = %{state | hash => status}
    notify_slack(hash, status)
    {:noreply, new_state}
  end

  # Priviate helping functions
  defp schedule_work(hash) do
    Process.send_after(self(), {:notify_slack, hash}, :timer.minutes(2))
  end

  defp is_pending_transaction({_hash, status}) do
    status != "confirmed"
  end

  defp notify_slack(hash, status) do
    message_body = %{
      "hash" => hash,
      "status" => status
    }

    notify_slack(message_body)
  end

  defp notify_slack(message_body) do
    Task.start(Slack, :webhook_post, [message_body])
  end
end
