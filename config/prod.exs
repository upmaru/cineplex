use Mix.Config

config :exq,
  url: "${REDIS_URL}"

config :pid_file,
  file: "${PID_FILE_LOCATION}"
