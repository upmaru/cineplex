use Mix.Config

config :compressor, :adapters, %{
  "upmaru_studio" => Compressor.Adapters.UpmaruStudio
}

# can be worker or server
config :compressor, :role, "server"

# config :compressor, :old, %{
#   name: "Codemy Staging",
#   endpoint: "https://staging.codemy.net",
#   adapter: Compressor.Adapters.UpmaruStudio,
#   token: "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJTdHVkaW8iLCJleHAiOjE1NDQ2MDY0OTYsImlhdCI6MTU0MjAxNDQ5NiwiaXNzIjoiU3R1ZGlvIiwianRpIjoiMjgwNjJkMTMtMDNmZi00Y2E5LWJhNzAtZmVmODk1YWFjOTE1IiwibmJmIjoxNTQyMDE0NDk1LCJwZW0iOnsiYm90IjozfSwic3ViIjoiMiIsInR5cCI6ImFjY2VzcyJ9.lBT6sldgBh8IBOuVQzrYZx8HT-KlRpFoMj8bgf_4Xg4lpAzp9U4Ar_-bG_CT8_dPwytGUHiDTZM78JiYuj3U4A"
# }

config :compressor, Compressor.Repo,
  database: "compressor_dev",
  username: "zacksiri",
  hostname: "localhost"
