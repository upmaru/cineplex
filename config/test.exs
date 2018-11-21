use Mix.Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :cineplex, Cineplex.Repo,
  database: "cineplex_test",
  username: "zacksiri",
  hostname: "localhost"
