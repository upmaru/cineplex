use Mix.Config

config :exq,
  name: Exq,
  host: "${REDIS_HOST}",
  port: 6379,
  namespace: "exq",
  concurrency: 1,
  queues: ["encoder"],
  start_on_application: false