defmodule Compressor.Distribution.Worker.Distribute do
  alias Compressor.{
    Queue,
    Distribution
  }

  alias Compressor.Worker

  @spec to(Distribution.Worker.t()) :: :no_job | Task.t()
  def to(%Distribution.Worker{node_name: node_name} = _worker) do
    job_entry = Queue.get_job_entry(:waiting)

    {Compressor.TaskSupervisor, String.to_atom(node_name)}
    |> Task.Supervisor.async(Worker, :perform, [job_entry])
  end
end
