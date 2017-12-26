defmodule Cumulus.Setting do
  @moduledoc """
  The Setting Module stores the setting for a job. Settings tells the
  encoder where to store the file after encoding, and which presets
  to use.
  """

  use Agent

  def start_link(name, settings) do
    Agent.start_link(fn -> settings end, name: name)
  end

  def get(name, config) do
    Agent.get(name, fn settings ->
      settings[config]
    end)
  end
end
