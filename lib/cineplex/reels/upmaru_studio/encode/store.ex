defmodule Cineplex.Reels.UpmaruStudio.Encode.Store do
  alias Cineplex.Queue.Source
  alias Upstream.Uploader

  require Logger

  @spec perform(Cineplex.Queue.Source.t(), Source.Preset.t(), any(), [{:on_done, fun}]) ::
          {:error, :store_failed} | {:ok, :stored}
  def perform(
        %Source{} = _source,
        %Source.Preset{name: name} = _preset,
        transcoded_path,
        opts \\ []
      ) do
    case upload(transcoded_path, metadata(name)) do
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

  defp upload(transcoded_path, meta) do
    [_, name] = String.split(transcoded_path, "tmp/")
    Uploader.upload_file!(transcoded_path, name, meta)
  end

  defp metadata(name), do: %{preset_name: name, uploader: "cineplex"}
end
