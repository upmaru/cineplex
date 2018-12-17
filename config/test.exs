use Mix.Config


# can be worker or server
config :cineplex, :role, System.get_env("CINEPLEX_ROLE")

config :tesla, adapter: Tesla.Adapter.Hackney

config :logger, level: :warn

config :cineplex, Cineplex.Repo,
  database: "cineplex_test",
  username: System.get_env("DATABASE_POSTGRESQL_USERNAME") || "zacksiri",
  password: System.get_env("DATABASE_POSTGRESQL_PASSWORD") || "",
  hostname: "localhost"

config :appsignal, :config, active: false
