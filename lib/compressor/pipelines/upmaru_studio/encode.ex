defmodule Compressor.Pipelines.UpmaruStudio.Encode do
  alias Compressor.Queue.Job
  alias Compressor.Pipelines.UpmaruStudio.Encode

  def perform(%Job.Entry{job: job} = job_entry) do
    with {:ok, url, path} <- Encode.Setup.perform(job),
         {:ok, downloaded} <- Encode.Download.perform(url, path),
         {:ok, transcoded} <- Encode.Transcode.perform(job_entry)
    do

    else
      {:error, reason} -> {:error, reason}
    end
  end
end
