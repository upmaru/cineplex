defmodule Compressor.Uploader do
  @moduledoc """
  Handles uploading of finished encoding variation.
  """

  alias Upstream.Uploader

  def upload(file_path) do
    [_, name] = String.split(file_path, "tmp/")
    Uploader.upload_file!(file_path, name, self())

    case wait_for_uploader() do
      {:ok, result} -> {:ok, result}
      {:error, reason} -> {:error, reason}
    end
  end

  def wait_for_uploader() do
    receive do
      {:finished, result} -> {:ok, result}
      {:errored, reason} -> {:error, reason}
      _ -> wait_for_uploader()
    end
  end
end
