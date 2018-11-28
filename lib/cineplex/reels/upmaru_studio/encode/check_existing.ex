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
        find_matched(files, output_name)

      {:error, _} -> {:error, :check_existing_failed}
    end
  end

  defp find_matched(files, output_name) do
    matched_count =
      files
      |> Enum.filter(fn file ->
        file["fileName"] == output_name
      end)
      |> Enum.count()

    if matched_count == 0,
      do: {:ok, :not_encoded},
      else: {:error, :already_encoded}
  end
end
