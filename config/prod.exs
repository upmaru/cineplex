use Mix.Config

config :cineplex, :role, "${CINEPLEX_ROLE}"

config :cineplex, Cineplex.Repo,
  url: "${DATABASE_URL}",
  pool_size: "${DATABASE_POOL_SIZE}"

