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

  alias Upstream.B2

  alias HTTPoison.Error

  def perform(name, callback, token) do
    with {:ok, _pid} <- prepare(callback, token),
         {:ok, encode_presets} <- check_for_encoded_preset(name),
         {:ok, url, path} <- setup_download(name),
         {:ok, file_path} <- download_source(url, path) do
      encode_presets
      |> create_variations(file_path)
      |> Enum.to_list()
      |> finish
    else
      {:error, :already_encoded, existing} ->
        Events.track("already_encoded", %{"existing" => existing})
        finish(existing)

      {:error, reason} ->
        Events.track("#{reason}")
        finish([])
    end
  end

  defp prepare(callback, token) do
    headers = [{"Authorization", "Bearer #{token}"}, {"Content-Type", "application/json"}]

    with {:ok, response} <- HTTPoison.get(callback["settings"], headers),
         {:ok, settings} <- Poison.decode(response.body),
         {:ok, _pid} <- Current.start_link(settings["data"], callback["events"], headers) do
      Upstream.set_config(Current.storage())
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

    if File.exists?(path) do
      Events.track("file_exists")
      {:ok, path}
    else
      Events.track("downloading_source")
      Download.from(url, path: path)
    end
  end

  defp check_for_encoded_preset(name) do
    Events.track("check_for_encoded")

    case B2.List.by_file_name(name) do
      {:ok, %B2.List.FileNames{files: files}} ->
        existing =
          files
          |> Enum.map(fn file -> file["fileInfo"]["preset_name"] end)
          |> Enum.reject(&is_nil/1)

        encode_presets =
          Enum.reject(Current.presets(), fn preset ->
            Enum.member?(existing, preset["name"])
          end)

        if Enum.count(encode_presets) > 0 do
          {:ok, encode_presets}
        else
          {:error, :already_encoded, existing}
        end

      {:error, _reason} ->
        {:error, :check_for_encoded_preset}
    end
  end

  def encode_and_upload(options, file_path) do
    name = Map.get(options, "name")
    output_name = generate_output_name(name, file_path)
    metadata = %{preset_name: name, uploader: "compressor"}

    with :ok <- encode(file_path, output_name, options),
         {:ok, _file} <- Uploader.upload(output_name, metadata) do
      %{name: name, encoding: :ok, uploading: :ok}
    else
      {:error, reason} -> %{name: name, error: reason}
    end
  end

  defp encode(file_path, output_name, options) do
    name = Map.get(options, "name")

    if File.exists?(output_name) do
      Events.track("variation_#{name}_exists")
      :ok
    else
      Events.track("encoding_#{name}")
      Presets.streamable(file_path, output_name, options)
    end
  end

  defp create_variations(presets, file_path) do
    Task.Supervisor.async_stream(
      TaskSupervisor,
      presets,
      __MODULE__,
      :encode_and_upload,
      [file_path],
      max_concurrency: 2,
      timeout: :infinity
    )
  end

  defp finish(_results) do
    Upstream.reset()
    Current.stop()
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
