defmodule Compressor.Distribution.Worker.Distribute do
  alias Compressor.{
    Queue,
    Distribution
  }

  alias Queue.Job
  alias Compressor.Worker

  @spec to(Distribution.Worker.t()) :: :no_job | Task.t()
  def to(%Distribution.Worker{node_name: node_name} = _worker) do
    case Queue.get_job_entry(:waiting) do
      %Job.Entry{} = job_entry ->
        {Compressor.TaskSupervisor, String.to_atom(node_name)}
        |> Task.Supervisor.async(Worker, :perform, [job_entry])

      nil -> :no_job
    end
  end
end
