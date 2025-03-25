defmodule Remcal.Repo do
  use Ecto.Repo,
    otp_app: :remcal,
    adapter: Ecto.Adapters.SQLite3
end
