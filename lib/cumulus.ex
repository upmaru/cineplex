defmodule Cumulus do
  @moduledoc """
  Documentation for Cumulus.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Cumulus.hello
      :world

  """

  def config, do: Application.get_env(:cumulus, Cumulus)
  def config(key), do: Keyword.get(config(), key)
end
