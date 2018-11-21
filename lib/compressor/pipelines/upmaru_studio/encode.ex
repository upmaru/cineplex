defmodule Pipelines.UpmaruStudio.Encode do
  alias Compressor.Queue.Job
  alias Pipelines.UpmaruStudio.Encode
  alias Encode.{
    Setup, Download, Transcode
  }

  def perform(%Job.Entry{job: job} = job_entry) do
    with {:ok, url, path} <- Setup.perform(job),
         {:ok, downloaded} <- Download.perform(url, path),
         {:ok, transcoded} <- Transcode.perform(job)
    do

    else
      {:error, reason} -> {:error, reason}
    end
  end
end
