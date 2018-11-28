defmodule Cineplex.Reels.UpmaruStudio.Encode.Download do
  require Logger

  @spec perform(binary(), binary(), [{:on_fail, fun}]) ::
          {:ok, binary()} | {:error, :download_failed}
  def perform(url, path, opts \\ []) do
    with {:ok, file} <- File.open(path, [:write]),
         {:ok, _device} <- Downstream.get(url, file, timeout: :infinity) do
      {:ok, path}
    else
      _ ->
        on_fail(opts)
        {:error, :download_failed}
    end
  end

  defp on_fail(opts) do
    Keyword.get(opts, :on_fail, fn ->
      Logger.error("[Cineplex.Reels.UpmaruStudio.Encode.Download] failed")
    end).()
  end
end
