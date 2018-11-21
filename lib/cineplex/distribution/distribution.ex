defmodule Cineplex.Distribution do
  alias Cineplex.{
    Distribution,
    Repo
  }

  alias Distribution.Worker

  @spec register_worker(binary(), binary()) ::
          {:ok, Distribution.Worker.t()} | {:error, Ecto.Changeset.t()}
  def register_worker(node_name, state) do
    case Repo.get_by(Distribution.Worker, node_name: node_name) do
      nil -> %Distribution.Worker{node_name: node_name}
      worker -> worker
    end
    |> Distribution.Worker.changeset(%{current_state: state})
    |> Repo.insert_or_update()
  end

  @spec get_worker([{:node_name, binary()}]) :: Worker.t()
  def get_worker(node_name: node_name) do
    Repo.get_by(Worker, node_name: node_name)
  end

  @spec get_workers([{:state, binary()}]) :: [Worker.t()]
  def get_workers(state: current_state) do
    Worker
    |> Worker.Scope.by(state: current_state)
    |> Repo.all()
  end
end
