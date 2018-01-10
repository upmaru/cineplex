defmodule Compressor.Encoder do
  @moduledoc """
  Handles the encoding
  """
  alias Compressor.{
    Presets, TaskSupervisor, Current, Store
  }

  alias HTTPoison.Error

  @behaviour Honeydew.Worker

  require Logger

  def perform(name, callback, token) do
    with {:ok, _pid} <- prepare(callback, token),
         {:ok, url, path} <- setup_download(name),
         {:ok, file_path} <- download_source(url, path),
         do: create_variations(file_path)
  end

  def encode(options, file_path) do
    name = Map.get(options, "name")
    output_name = generate_output_name(name, file_path)

    Presets.streamable(file_path, output_name, options)
    Task.async(fn -> upload(output_name) end)
  end

  def upload(file_path) do
    name = Path.basename(file_path)
    Uploader.upload_file!(file_path, name)
  end

  def prepare(callback, token) do
    headers = ["Authorization": "Bearer #{token}"]

    with {:ok, response} <- HTTPoison.get(callback.setting, headers),
         {:ok, settings} <- Poison.decode(response.body),
         {:ok, _pid} <- Current.start_link(settings["data"]) do
      Upstream.set_config(Current.storage)
    else
      {:error, %Error{reason: reason}} -> {:error, reason}
    end
  end

  defp setup_download(name) do
    {:ok, auth} =
      name
      |> String.split("/")
      |> List.first
      |> Upstream.B2.Download.authorize(3600)

    path = "tmp/" <> name

    with :ok <- path |> Path.dirname |> File.mkdir_p,
         url <- Upstream.B2.Download.url(name, auth.authorization_token) do
      {:ok, url, path}
    end
  end

  defp download_source(url, path) do
    Logger.info "[Compressor] downloading #{path}"
    Download.from(url, [path: path])
  end

  defp create_variations(file_path) do
    Logger.info "[Compressor] encoding #{file_path}"

    Stream.run(
      Task.Supervisor.async_stream(
        TaskSupervisor,
        Current.presets,
        __MODULE__,
        :encode,
        [file_path],
        max_concurrency: 1,
        timeout: :infinity
      )
    )

    Logger.info "[Compressor] encoded #{file_path}"
  end

  defp generate_output_name(name, file_path) do
    [file_name, extension] =
      file_path
      |> Path.expand
      |> Path.basename
      |> String.split(".")

    Enum.join(
      [
        Path.dirname(file_path), "/",
        file_name, "_", name, ".", extension
      ]
    )
  end
end
