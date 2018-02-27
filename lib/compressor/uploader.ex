defmodule Compressor.Uploader do
  @moduledoc """
  Handles uploading of finished encoding variation.
  """

  alias Upstream.Uploader
  alias Compressor.Events

  def upload(file_path, metadata) do
    [_, name] = String.split(file_path, "tmp/")

    Events.track("uploading", metadata)

    case Uploader.upload_file!(file_path, name, metadata) do
      {:ok, result} ->
        Events.track("uploaded", metadata)
        {:ok, result}

      {:error, reason} ->
        Events.track("upload_failed", metadata)
        {:error, reason}
    end
  end
end
