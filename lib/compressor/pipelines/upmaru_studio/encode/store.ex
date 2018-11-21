defmodule Compressor.Pipelines.UpmaruStudio.Encode.Store do
  alias Compressor.Queue.Source
  alias Upstream.Uploader


  @spec perform(Compressor.Queue.Source.t(), Source.Preset.t(), any()) ::
          {:error, :store_failed} | {:ok, :stored}
  def perform(%Source{storage: storage} = _source, %Source.Preset{name: name} = _preset, transcoded_path) do
    with {:ok, [_apps]} <- Upstream.set_config(to_keyword_list(storage)),
         {:ok, _} <- upload(transcoded_path, metadata(name))
    do
      {:ok, :stored}
    else
      _ -> {:error, :store_failed}
    end
  end

  defp upload(transcoded_path, meta) do
    [_, name] = String.split(transcoded_path, "tmp/")
    Uploader.upload_file!(transcoded_path, name, meta)
  end

  defp metadata(name), do: %{preset_name: name, uploader: "compressor"}

  defp to_keyword_list(config) do
    config
    |> Enum.into([])
    |> Enum.map(fn {key, value} ->
      {String.to_atom(key), value}
    end)
  end
end
