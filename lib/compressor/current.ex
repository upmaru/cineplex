defmodule Compressor.Current do
  @moduledoc """
  The Setting Module stores the setting for a job. Settings tells the
  encoder where to store the file after encoding, and which presets
  to use.
  """

  use Agent

  def start_link(configuration, resource_url, headers) do
    Agent.start_link(
      fn ->
        %{
          resource: %{
            url: resource_url,
            headers: headers
          },
          storage: to_keyword_list(configuration["storage"]),
          presets: configuration["presets"]
        }
      end,
      name: __MODULE__
    )
  end

  def resource do
    Agent.get(__MODULE__, fn configuration ->
      configuration.resource
    end)
  end

  def storage do
    Agent.get(__MODULE__, fn configuration ->
      configuration.storage
    end)
  end

  def presets do
    Agent.get(__MODULE__, fn configuration ->
      configuration.presets
    end)
  end

  defp to_keyword_list(config) do
    config
    |> Enum.into([])
    |> Enum.map(fn {key, value} ->
      {String.to_atom(key), value}
    end)
  end
end
