use Mix.Config


# can be worker or server
config :cineplex, :role, System.get_env("CINEPLEX_ROLE")

config :tesla, adapter: Tesla.Adapter.Hackney

config :cineplex, Cineplex.Repo,
  database: "cineplex_test",
  username: "zacksiri",
  hostname: "localhost"

config :appsignal, :config, active: false
