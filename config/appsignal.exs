use Mix.Config

config :appsignal, :config,
  name: "${APPSIGNAL_APP_NAME}",
  push_api_key: "${APPSIGNAL_API_KEY}",
  env: "${APPSIGNAL_ENV}"
