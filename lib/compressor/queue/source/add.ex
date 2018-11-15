defmodule Compressor.Queue.Source.Add do
  alias Compressor.{
    Queue,
    Repo
  }

  alias Queue.Source

  @spec perform(binary(), binary(), binary()) ::
          {:ok, %{source: Source.t(), presets: [Source.Preset.t()]}}
          | {:error, Ecto.Changeset.t() | atom}
  def perform(endpoint, token, adapter) do
    with {:ok, source} <- Queue.create_source(endpoint, token, adapter),
         {:ok, setting} <- load_setting(source),
         {_count, created_presets} <- insert_all_presets(source, setting),
         {:ok, source_with_storage} <- Queue.update_source(source, %{storage: setting.storage}) do
      {:ok, %{source: source_with_storage, presets: created_presets}}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp load_setting(%{token: token, endpoint: endpoint} = source) do
    adapter = Compressor.Adapter.from_source(source)
    client = adapter.client(endpoint, token)

    adapter.setting(client)
  end

  defp insert_all_presets(source, %{presets: presets} = _setting) do
    source_presets = Enum.map(presets, &preset_from_params(&1, source))

    Repo.insert_all(Source.Preset, source_presets)
  end

  defp preset_from_params(preset, source) do
    timestamp = DateTime.truncate(DateTime.utc_now(), :second)

    %{
      source_id: source.id,
      parameters: preset,
      name: preset["name"],
      inserted_at: timestamp,
      updated_at: timestamp
    }
  end
end
