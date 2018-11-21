defmodule Cineplex.Worker.Registration do
  alias Cineplex.Distribution

  require Logger

  @spec perform() :: {:error, Ecto.Changeset.t()} | {:ok, any()}
  def perform do
    with {:ok, _node} <- Distribution.register_node(Atom.to_string(node()), "worker", "ready"),
         :ok <- connect_to_servers() do
      Logger.info("[Cineplex.Worker.Registration] Successful")
      {:ok, :registered}
    else
      {:error, changeset} -> {:error, changeset}
      false -> {:error, :failed}
      :ignored -> {:error, :node_unavailable}
    end
  end

  defp connect_to_servers do
    servers = Distribution.get_servers(current_state: "ready")
    Enum.each(servers, &connect/1)
  end

  defp connect(%Distribution.Node{name: name}), do: Node.connect(String.to_atom(name))
end
