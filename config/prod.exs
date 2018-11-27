use Mix.Config

config :cineplex, :role, "${CINEPLEX_ROLE}"

config :cineplex, Cineplex.Repo,
  url: "${DATABASE_URL}"

config :appsignal, :config, active: true
