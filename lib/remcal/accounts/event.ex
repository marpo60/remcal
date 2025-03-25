defmodule Remcal.Accounts.Event do
  use Ecto.Schema

  import Ecto.Changeset

  alias Remcal.Accounts.User

  schema "events" do
    field(:title, :string)
    field(:description, :string)
    field(:date, :date)
    field(:reminder_start_date, :date)
    field(:done, :boolean)

    belongs_to(:user, User)

    timestamps(type: :utc_datetime)
  end

  def changeset(event, params \\ %{}) do
    fields = [:user_id, :title, :description, :date, :reminder_start_date, :done]

    event
    |> cast(params, fields)
    |> validate_required([:user_id, :title, :date])
  end
end
