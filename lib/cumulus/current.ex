defmodule Cumulus.Current do
  @moduledoc """
  The Setting Module stores the setting for a job. Settings tells the
  encoder where to store the file after encoding, and which presets
  to use.
  """

  use Agent

  def start_link(settings) do
    Agent.start_link(fn -> settings end, name: __MODULE__)
  end

  def storage do
    Agent.get(__MODULE__, fn settings ->
      Enum.into(settings.storage, [])
    end)
  end

  def presets do
    Agent.get(__MODULE__, fn settings -> settings.presets end)
  end
end
