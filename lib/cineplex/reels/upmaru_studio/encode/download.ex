defmodule Cineplex.Reels.UpmaruStudio.Encode.Download do
  @spec perform(binary(), binary()) :: {:ok, binary()} | {:error, :download_failed}
  def perform(url, path) do
    with {:ok, file} <- File.open(path, [:write]),
         {:ok, _device} <- Downstream.get(url, file, timeout: :infinity) do
      {:ok, path}
    else
      _ -> {:error, :download_failed}
    end
  end
end
