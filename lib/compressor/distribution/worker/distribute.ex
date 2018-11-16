defmodule Compressor.Distribution.Worker.Distribute do
  alias Compressor.{
    Distribution, Worker
  }

  @spec perform(Distribution.Worker.t()) :: Task.t()
  def perform({%Distribution.Worker{node_name: node_name} = _worker, job_entry}) do
    {Compressor.TaskSupervisor, String.to_atom(node_name)}
    |> Task.Supervisor.async(Worker, :perform, [job_entry])
  end
end
