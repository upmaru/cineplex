defmodule Cineplex.Distribution.Worker.Distribute do
  alias Cineplex.{
    Distribution,
    Worker
  }

  @spec perform(Distribution.Worker.t()) :: Task.t()
  def perform({%Distribution.Worker{node_name: node_name} = _worker, job_entry}) do
    {Cineplex.TaskSupervisor, String.to_atom(node_name)}
    |> Task.Supervisor.async(Worker, :perform, [job_entry])
  end
end
