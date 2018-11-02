use Mix.Config

config :compressor, Compressor.Repo,
  database: "compressor_dev",
  username: "zacksiri",
  hostname: "localhost"

config :exq,
  url: "redis://127.0.0.1:6379/0"
