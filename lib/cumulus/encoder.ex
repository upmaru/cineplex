defmodule Cumulus.Encoder do
  @moduledoc """
  Handles the encoding
  """
  alias Cumulus.{
    Presets, TaskSupervisor, Setting
  }

  alias HTTPoison.{
    Response, Error
  }

  @behaviour Honeydew.Worker
  use Honeydew.Progress

  def perform(name, setting_url, token) do
    {:ok, _pid} = prepare(name, setting_url, token)

    # with {:ok, file_path} <- Download.from(source_url, [path: name]),
    #   do: create_variations(file_path)
  end

  def encode(options, file_path) do
    name = Map.get(options, :name)
    output_name = generate_output_name(name, file_path)

    Presets.streamable(file_path, output_name, options)
    progress("-----> encoded #{name}")
  end

  defp prepare(name, setting_url, token) do
    headers = ["Authorization": "Bearer #{token}"]
    case HTTPoison.get(setting_url, headers) do
      {:ok, %Response{status_code: 200, body: body}} ->
        body
        |> Poison.decode!
        |> Setting.start_link
      {:error, %Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp get_download_url(name) do
    
  end

  defp create_variations(file_path) do
    tasks =
      Task.Supervisor.async_stream(
        TaskSupervisor,
        Cumulus.config(:presets),
        __MODULE__,
        :encode,
        [file_path],
        max_concurrency: 1,
        timeout: :infinity
      )

    Enum.to_list(tasks)
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