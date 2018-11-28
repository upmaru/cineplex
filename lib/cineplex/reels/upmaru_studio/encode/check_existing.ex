defmodule Cineplex.Reels.UpmaruStudio.Encode.CheckExisting do
  alias Cineplex.Queue.Source.Preset
  alias Cineplex.Reels.UpmaruStudio.Encode.Transcode
  alias Upstream.B2

  @spec perform(Preset.t(), binary()) ::
          {:error, :already_encoded | :check_existing_failed} | {:ok, :not_encoded}
  def perform(%Preset{name: name} = _preset, path) do
    output_name = Transcode.output_name(name, path)

    case B2.List.by_file_name(output_name) do
      {:ok, %{files: []}} -> {:ok, :not_encoded}
      {:ok, %{files: _files}} -> {:error, :already_encoded}
      {:error, _} -> {:error, :check_existing_failed}
    end
  end
end
