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

  def source(key), do: Keyword.get(Application.get_env(:compressor, :source), key, nil)
  def config, do: Application.get_env(:compressor, Compressor)

  def config(key), do: Keyword.get(config(), key)
end
