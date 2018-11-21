defmodule Cineplex.Distribution.Node.Distribute do
  alias Cineplex.{
    Distribution,
    Worker
  }

  @spec perform(Distribution.Node.t()) :: Task.t()
  def perform({%Distribution.Node{name: name} = _worker, job_entry}) do
    {Cineplex.TaskSupervisor, String.to_atom(name)}
    |> Task.Supervisor.async(Worker, :perform, [job_entry])
  end
end
