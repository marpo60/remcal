defmodule Remcal.Workers.ReminderWorker do
  use Oban.Worker

  alias Remcal.Accounts

  alias Remcal.Workers.ReminderWorker.Mailer, as: ReminderMailer

  @impl Oban.Worker
  def perform(%Oban.Job{args: _args}) do
    Accounts.list_user_with_events_for_reminders(Date.utc_today())
    |> Enum.map(fn({u, events}) ->
      ReminderMailer.deliver(u, events)
    end)

    :ok
  end
end

defmodule Remcal.Workers.ReminderWorker.Mailer do
  import Swoosh.Email

  alias Remcal.Mailer

  # Delivers the email using the application mailer.
  def deliver(user, events) do
    email =
      new()
      |> to(user.email)
      |> from({"Remcal", "remcal@marpo60.xyz"})
      |> subject("Reminders")
      |> text_body("""
        You have the following reminders:

        #{for event <- events, do: build_event(event)}

        Bye
      """)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  defp build_event(event) do
    """
    #{event.title} - #{event.date} (id: #{event.id})
    #{event.description}

    """
  end
end
