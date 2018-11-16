defmodule Compressor.Pipelines.UpmaruStudio.Encode.Download do
  alias Compressor.Queue.Job

  alias Pipelines.UpmaruStudio.Encode.Download

  @spec perform(Job.t()) :: {:ok, binary()} | {:error, :download_failed}
  def perform(%Job{object: object} = _job) do
    with {:ok, url, path} <- Download.Setup.perform(object),
         file <- File.open!(path, [:write]),
         {:ok, _device} <- Downstream.get(url, file, timeout: :infinity)
    do

    else
      {:error, _reason} -> {:error, :download_failed}
    end
    case Download.Setup.perform(object) do
      {:ok, url, path} ->
        file = File.open!(path, [:write])
        case Downstream.get(url, file, timeout: :infinity) do
          {:ok, _device} -> {:ok, path}
          {:error, _reason} -> {:error, :download_failed}
        end

      {:error, :setup_failed} -> {:error, :download_failed}
    end
  end
end
