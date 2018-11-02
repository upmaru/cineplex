defmodule Compressor.Job do
  use Ecto.Schema

  schema "jobs" do
    field :metadata, :map
    field :source, :string
  end
end
