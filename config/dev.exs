use Mix.Config

# can be worker or server
config :cineplex, :role, System.get_env("CINEPLEX_ROLE")

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
