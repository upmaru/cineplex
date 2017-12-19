defmodule Cumulus.Encoder do
  @moduledoc """
  Handles the encoding
  """
  alias Cumulus.{
    Presets, TaskSupervisor
  }

  @behaviour Honeydew.Worker
  use Honeydew.Progress

  def perform(file_path) do
    Task.Supervisor.async_stream(
      TaskSupervisor,
      Cumulus.config(:presets), 
      __MODULE__, 
      :encode, 
      [file_path], 
      max_concurrency: 2,
      timeout: :infinity
    ) |> Stream.run
  end

  def encode(options, file_path) do
    name = Keyword.get(options, :name)
    output_name = generate_output_name(name, file_path)

    Presets.streamable(file_path, output_name, options)
  end

  defp generate_output_name(name, file_path) do
    [file_name, extension] = 
      file_path
      |> Path.expand
      |> Path.basename
      |> String.split(".")

    Enum.join([file_name, "_", name, ".", extension]) 
  end
end