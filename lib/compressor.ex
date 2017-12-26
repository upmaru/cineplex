defmodule Compressor do
  @moduledoc """
  Documentation for Compressor.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Compressor.hello
      :world

  """

  def config, do: Application.get_env(:Compressor, Compressor)
  def config(key), do: Keyword.get(config(), key)
end
