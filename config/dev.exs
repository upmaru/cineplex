use Mix.Config

config :cineplex, :pipelines, %{
  "upmaru_studio" => Pipelines.UpmaruStudio
}

# can be worker or server
config :cineplex, :role, "server"

config :cineplex, :worker,
  server: :cineplex_server@oneeight

# configuration for server
config :cineplex, :server,
  poller: false

# config :cineplex, :old, %{
#   name: "Codemy Staging",
#   endpoint: "https://staging.codemy.net",
#   adapter: Cineplex.Adapters.UpmaruStudio,
#   token: "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJTdHVkaW8iLCJleHAiOjE1NDQ2MDY0OTYsImlhdCI6MTU0MjAxNDQ5NiwiaXNzIjoiU3R1ZGlvIiwianRpIjoiMjgwNjJkMTMtMDNmZi00Y2E5LWJhNzAtZmVmODk1YWFjOTE1IiwibmJmIjoxNTQyMDE0NDk1LCJwZW0iOnsiYm90IjozfSwic3ViIjoiMiIsInR5cCI6ImFjY2VzcyJ9.lBT6sldgBh8IBOuVQzrYZx8HT-KlRpFoMj8bgf_4Xg4lpAzp9U4Ar_-bG_CT8_dPwytGUHiDTZM78JiYuj3U4A"
# }

config :cineplex, Cineplex.Repo,
  database: "cineplex_dev",
  username: "zacksiri",
  hostname: "localhost"
