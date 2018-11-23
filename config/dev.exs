use Mix.Config

# can be worker or server
config :cineplex, :role, System.get_env("CINEPLEX_ROLE")

config :cineplex, Cineplex.Repo,
  database: "cineplex_dev",
  username: "zacksiri",
  hostname: "localhost"
