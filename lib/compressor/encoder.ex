defmodule Compressor.Encoder do
  @moduledoc """
  Handles the encoding
  """

  alias Compressor.{
    Presets,
    TaskSupervisor,
    Current,
    Uploader,
    Events
  }

  alias HTTPoison.Error
  require Logger

  require IEx

  def perform(name, callback, token) do
    with {:ok, _pid} <- prepare(callback, token),
         {:ok, url, path} <- setup_download(name),
         {:ok, file_path} <- download_source(url, path) do

      file_path
      |> create_variations
      |> Enum.to_list
    end
  end

  def encode_and_upload(options, file_path) do
    name = Map.get(options, "name")
    output_name = generate_output_name(name, file_path)

    encoding =
      if File.exists?(output_name) do
        Events.track("variation_#{name}_exists")
        :ok
      else
        Events.track("encoding_#{name}")
        Presets.streamable(file_path, output_name, options)
      end

    case Uploader.upload(output_name) do
      {:ok, result} ->
        %{name: name, encoding: encoding, uploading: :ok}

      {:error, reason} ->
        %{name: name, encoding: encoding, uploading: :error}
    end
  end

  def prepare(callback, token) do
    headers = [{"Authorization", "Bearer #{token}"}, {"Content-Type", "application/json"}]

    with {:ok, response} <- HTTPoison.get(callback["settings"], headers),
         {:ok, settings} <- Poison.decode(response.body),
         {:ok, _pid} <- Current.start_link(settings["data"], callback["resource"], headers) do
      Upstream.set_config(Current.storage())
      Events.start_link()
    else
      {:error, %Error{reason: reason}} -> {:error, reason}
    end
  end

  defp setup_download(name) do
    Events.track("starting")
    {:ok, auth} =
      name
      |> String.split("/")
      |> List.first()
      |> Upstream.B2.Download.authorize(3600)

    path = "tmp/" <> name

    with :ok <- path |> Path.dirname() |> File.mkdir_p(),
         url <- Upstream.B2.Download.url(name, auth.authorization_token) do
      {:ok, url, path}
    end
  end

  defp download_source(url, path) do
    Events.track("checking_source")
    Logger.info("[Compressor] checking_source")

    if File.exists?(path) do
      Events.track("file_exists")
      Logger.info("[Compressor] file_exists")
      {:ok, path}
    else
      Events.track("downloading_source")
      Logger.info("[Compressor] downloading_source")
      Download.from(url, path: path)
    end
  end

  defp create_variations(file_path) do
    Events.track("creating_variations")
    Logger.info("[Compressor] creating_variations")

    Task.Supervisor.async_stream(
      TaskSupervisor,
      Current.presets(),
      __MODULE__,
      :encode_and_upload,
      [file_path],
      max_concurrency: 2,
      timeout: :infinity
    )
  end

  defp generate_output_name(name, file_path) do
    [file_name, extension] =
      file_path
      |> Path.expand()
      |> Path.basename()
      |> String.split(".")

    Enum.join([
      Path.dirname(file_path),
      "/",
      file_name,
      "_",
      name,
      ".",
      extension
    ])
  end
end
