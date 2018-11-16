defmodule Pipelines.UpmaruStudio.Encode do
  alias Compressor.Queue.Job
  alias Pipelines.UpmaruStudio.Encode

  def perform(%Job.Entry{job: job} = job_entry) do
    Encode.Download.perform(job.object)
  end
end
