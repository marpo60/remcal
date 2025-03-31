defmodule Remcal.Workers.ReminderWorker do
  use Oban.Worker

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    # Send emails for reminders
    :ok
  end
end
