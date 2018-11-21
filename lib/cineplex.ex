defmodule Cineplex do
  @moduledoc """
  Cineplex is a distributed video encoder, it has a server part and a worker part.
  If you have videos that need to be transcoded into multiple formats / sizes,
  cineplex will distribute your work into multiple machines and run the encoding jobs.
  """

  @spec config() :: any()
  def config, do: Application.get_env(:cineplex, Cineplex)

  @spec config(atom()) :: any()
  def config(key), do: Keyword.get(config(), key)
end
