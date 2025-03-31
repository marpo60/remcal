import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :remcal, Remcal.Repo,
  database: Path.expand("../remcal_test.db", __DIR__),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# Oban
config :remcal, Oban, testing: :manual

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :remcal, RemcalWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "AEbKMyiEjF3vvxcPnq17l2TKBss4Dwr+Iyr6n4MVmm/4i5F/u6SCvOuIa2XQVisi",
  server: false

# In test we don't send emails
config :remcal, Remcal.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
