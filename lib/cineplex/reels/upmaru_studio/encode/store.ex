defmodule Cineplex.Reels.UpmaruStudio.Encode.Store do
  alias Cineplex.Queue.Source
  alias Upstream.Uploader

  @spec perform(Cineplex.Queue.Source.t(), Source.Preset.t(), any()) :: {:error, :store_failed} | {:ok, :stored}
  def perform(%Source{} = _source, %Source.Preset{name: name} = _preset, transcoded_path) do
    case upload(transcoded_path, metadata(name)) do
      {:ok, _} -> {:ok, :stored}
      _ -> {:error, :store_failed}
    end
  end

  defp upload(transcoded_path, meta) do
    [_, name] = String.split(transcoded_path, "tmp/")
    Uploader.upload_file!(transcoded_path, name, meta)
  end

  defp metadata(name), do: %{preset_name: name, uploader: "cineplex"}
end
