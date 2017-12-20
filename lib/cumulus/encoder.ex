defmodule Cumulus.Encoder do
  @moduledoc """
  Handles the encoding
  """
  alias Cumulus.{
    Presets, TaskSupervisor
  }

  @setting_id "encoder"

  @behaviour Honeydew.Worker
  use Honeydew.Progress

  def perform(name, owner, token) do
    # with {:ok, file_path} <- Download.from(source_url, [path: name]),
    #   do: create_variations(file_path)
  end

  def encode(options, file_path) do
    name = Map.get(options, :name)
    output_name = generate_output_name(name, file_path)

    Presets.streamable(file_path, output_name, options)
    progress("-----> encoded #{name}")
  end

  defp prepare(token) do
    
  end

  defp get_download_url(name) do
    
  end

  defp create_variations(file_path) do
    Task.Supervisor.async_stream(
      TaskSupervisor,
      Cumulus.config(:presets), 
      __MODULE__, 
      :encode, 
      [file_path], 
      max_concurrency: 2,
      timeout: :infinity
    ) |> Enum.to_list
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