defmodule Compressor.Current do
  @moduledoc """
  The Setting Module stores the setting for a job. Settings tells the
  encoder where to store the file after encoding, and which presets
  to use.
  """

  use Agent

  def start_link(configuration) do
    Agent.start_link(fn -> configuration end, name: __MODULE__)
  end

  def storage do
    Agent.get(__MODULE__, fn configuration ->
      Enum.into(configuration.storage, [])
    end)
  end

  def presets do
    Agent.get(__MODULE__, fn configuration ->
      configuration.presets
    end)
  end
end
