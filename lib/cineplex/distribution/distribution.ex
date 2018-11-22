defmodule Cineplex.Distribution do
  alias Cineplex.{
    Distribution,
    Repo
  }


  @spec register_node(binary(), binary(), binary()) ::
          {:ok, Distribution.Node.t()} | {:error, Ecto.Changeset.t()}
  def register_node(name, role, state) do
    case Repo.get_by(Distribution.Node, name: name, role: role) do
      nil -> %Distribution.Node{name: name, role: role}
      worker -> worker
    end
    |> Distribution.Node.changeset(%{current_state: state, role: role})
    |> Repo.insert_or_update()
  end

  @spec get_node([{:name, binary()}]) :: Distribution.Node.t()
  def get_node(name: name) do
    Repo.get_by(Distribution.Node, name: name)
  end

  @spec get_nodes([{:state, binary()}, ...]) :: any()
  def get_nodes(state: current_state) do
    Distribution.Node
    |> Distribution.Node.Scope.by(state: current_state)
    |> Repo.all()
  end

  @spec get_worker([{:name, binary()}]) :: Distribution.Node.t()
  def get_worker(name: name) do
    Repo.get_by(Distribution.Node, name: name, role: "worker")
  end

  @spec get_servers([{:state, binary()}]) :: [Distribution.Node.t()]
  def get_servers(state: current_state) do
    Distribution.Node
    |> Distribution.Node.Scope.by("server", state: current_state)
    |> Repo.all()
  end

  @spec get_other_nodes(binary(), [{:state, binary()}]) :: [Distribution.Node.t()]
  def get_other_nodes(name, state: current_state) do
    Distribution.Node
    |> Distribution.Node.Scope.except(name)
    |> Distribution.Node.Scope.by(state: current_state)
    |> Repo.all()
  end

  @spec get_workers([{:state, binary()}]) :: [Distribution.Node.t()]
  def get_workers(state: current_state) do
    Distribution.Node
    |> Distribution.Node.Scope.by("worker", state: current_state)
    |> Repo.all()
  end
end
