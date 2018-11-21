defmodule Cineplex.Server do
  use Task, restart: :transient

  alias Cineplex.Distribution

  @spec start_link() :: any()
  def start_link do
    Task.start_link(__MODULE__, :register, [])
  end

  @spec register() :: {:error, Ecto.Changeset.t()} | {:ok, :connected}
  def register do
    with {:ok, _node} <- Distribution.register_node(Atom.to_string(node()), "server", "ready"),
         :ok <- connect_to_others(), do: {:ok, :connected}
  end

  defp connect_to_others do
    node()
    |> Atom.to_string()
    |> Distribution.get_other_servers(state: "ready")
    |> Enum.each(&connect/1)
  end

  defp connect(%Distribution.Node{name: name} = _node), do: Node.connect(String.to_atom(name))
end
