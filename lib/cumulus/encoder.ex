defmodule Cumulus.Encoder do
  @moduledoc """
  Handles the encoding
  """
  alias Cumulus.{
    Presets, TaskSupervisor, Current
  }

  alias HTTPoison.{
    Response, Error
  }

  alias Posion.Parser

  @behaviour Honeydew.Worker
  use Honeydew.Progress

  def perform(name, setting_url, token) do
    with {:ok, _pid} <- prepare(name, setting_url, token),
         url <- get_download_url(name),
         {:ok, file_path} <- Download.from(url, [path: name]),
         do: create_variations(file_path)
  end

  def encode(options, file_path) do
    name = Map.get(options, :name)
    output_name = generate_output_name(name, file_path)

    Presets.streamable(file_path, output_name, options)
    progress("-----> encoded #{name}")
  end

  defp prepare(name, setting_url, token) do
    headers = ["Authorization": "Bearer #{token}"]

    with {:ok, response} <- HTTPoison.get(setting_url, headers),
         {:ok, settings} <- Parser.parse(response.body, keys: :atoms!),
         {:ok, _pid} <- Current.start_link(settings) do
      Blazay.set_config(Current.storage)
    else
      {:error, %Error{reason: reason}} -> {:error, reason}
    end
  end

  defp get_download_url(name) do
    {:ok, token} =
      name
      |> String.split("/")
      |> List.first
      |> Blazay.B2.Download.authorize(3600)

    Blazay.B2.Download.url(name, token)
  end

  defp create_variations(file_path) do
    task =
      Task.Supervisor.async_stream(
        TaskSupervisor,
        Cumulus.config(:presets),
        __MODULE__,
        :encode,
        [file_path],
        max_concurrency: 1,
        timeout: :infinity
      )

    Enum.to_list(task)
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
