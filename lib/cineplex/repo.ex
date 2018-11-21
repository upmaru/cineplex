defmodule Cineplex.Repo do
  use Ecto.Repo,
    otp_app: :cineplex,
    adapter: Ecto.Adapters.Postgres
end
