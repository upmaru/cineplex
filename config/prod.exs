use Mix.Config

config :exq,
  name: Exq,
  url: "${REDIS_URL}"
  namespace: "exq",
  concurrency: 1,
  queues: ["encoder"],
  start_on_application: false