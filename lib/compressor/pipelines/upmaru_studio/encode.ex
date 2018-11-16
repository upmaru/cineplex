defmodule Compressor.Pipelines.UpmaruStudio.Encode do
  alias Compressor.Queue.Job
  alias Pipelines.UpmaruStudio.Encode

  @spec perform(Compressor.Queue.Job.Entry.t()) :: any()
  def perform(%Job.Entry{job: job} = job_entry) do
    Encode.Download.perform(job)
  end
end
