defmodule Cineplex.Reels.UpmaruStudio.Encode.Store do
  alias Cineplex.Queue.Source
  alias Upstream.B2

  require Logger

  @spec perform(B2.Account.Authorization.t(), Source.Preset.t(), any(), [{:on_done, fun}]) ::
          {:error, :store_failed} | {:ok, :stored}
  def perform(
        %B2.Account.Authorization{} = authorization,
        %Source.Preset{name: name} = _preset,
        transcoded_path,
        opts \\ []
      ) do
    case upload(authorization, transcoded_path, metadata(name)) do
      {:ok, _} ->
        on_done(opts)
        {:ok, :stored}

      _ ->
        {:error, :store_failed}
    end
  end

  defp on_done(opts) do
    Keyword.get(opts, :on_done, fn ->
      Logger.info("[Cineplex.Reels.UpmaruStudio.Encode.Store] done")
    end).()
  end

  defp upload(authorization, transcoded_path, meta) do
    [_, name] = String.split(transcoded_path, "tmp/")
    B2.upload_file(authorization, transcoded_path, name, meta)
  end

  defp metadata(name), do: %{preset_name: name, uploader: "cineplex"}
end
