use Mix.Config

config :exq,
  name: Exq,
  url: "redis://127.0.0.1:6379/0"
  namespace: "exq",
  concurrency: 1,
  queues: ["encoder"],
  start_on_application: false