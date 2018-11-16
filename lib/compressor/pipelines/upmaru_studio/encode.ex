defmodule Pipelines.UpmaruStudio.Encode do
  alias Compressor.Queue.Job
  alias Pipelines.UpmaruStudio.Encode

  def perform(%Job.Entry{job: job} = job_entry) do
    with {:ok, url, path} <- Encode.Setup.perform(job),
         {:ok, downloaded} <- Encode.Download.perform(url, path),
         {:ok, transcoded} <- Encode.Transcode.perform(job)
    do

    else
      {:error, reason} -> {:error, reason}
    end
  end
end
