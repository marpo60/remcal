defmodule Remcal.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string, null: false
      add :description, :string
      add :date, :date, null: false
      add :reminder_start_date, :date
      add :done, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:events, [:user_id])
  end
end
