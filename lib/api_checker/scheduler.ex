defmodule ApiChecker.Scheduler do
  @moduledoc """
  Responsible for making sure tasks run as scheduled.
  """

  use GenServer
  alias ApiChecker.TaskRunner

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    Process.send_after(self(), :perform, 5_000)
    {:ok, nil}
  end

  def handle_info(:perform, state) do
    tasks = ApiChecker.tasks_due()
    TaskRunner.perform(tasks)
    Process.send_after(self(), :perform, 10_000)
    {:noreply, state, state}
  end
end
