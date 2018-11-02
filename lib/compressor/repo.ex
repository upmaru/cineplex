defmodule Compressor.Repo do
  use Ecto.Repo,
    otp_app: :compressor,
    adapter: Ecto.Adapters.Postgres
end
