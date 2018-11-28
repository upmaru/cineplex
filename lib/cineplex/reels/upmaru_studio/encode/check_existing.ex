defmodule Cineplex.Reels.UpmaruStudio.Encode.CheckExisting do
  alias Cineplex.Queue.{
    Job,
    Source
  }

  alias Cineplex.Reels.UpmaruStudio.Encode.Transcode
  alias Upstream.B2

  @spec perform(Job.t(), Source.Preset.t()) ::
          {:error, :already_encoded | :check_existing_failed} | {:ok, :not_encoded}
  def perform(%Job{object: object}, %Source.Preset{name: name}) do
    output_name = Transcode.output_name(name, object)

    case B2.List.by_file_name(output_name) do
      {:ok, %{files: []}} -> {:ok, :not_encoded}
      {:ok, %{files: files}} ->
        find_match(files, output_name)

      {:error, _} -> {:error, :check_existing_failed}
    end
  end

  def find_match(files, output_name) do
    matched_count =
      files
      |> Enum.filter(&(match_by_filename(&1, output_name))
      |> Enum.count()

    if matched_count > 0 do
      {:error, :already_encoded}
    else
      {:ok, :not_encoded}
    end
  end

  defp match_by_file_name(file, output_name) do
    file["fileName"] == output_name
  end
end
