use Mix.Config

config :cineplex, :role, "${CINEPLEX_ROLE}"

config :cineplex, Cineplex.Repo,
  ssl: true,
  url: "${DATABASE_URL}",
  pool_size: "${DATABASE_POOL_SIZE}"

