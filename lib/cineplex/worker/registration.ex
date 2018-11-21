defmodule Cineplex.Worker.Registration do
  alias Cineplex.Distribution

  require Logger

  @spec perform() :: {:error, Ecto.Changeset.t()} | {:ok, any()}
  def perform do
    with {:ok, _worker} <- Distribution.register_worker(Atom.to_string(node()), "ready"),
         true <- Node.connect(server_node()) do
      Logger.info("[Cineplex.Worker.Registration] Successful")
      {:ok, :registered}
    else
      {:error, changeset} -> {:error, changeset}
      false -> {:error, :failed}
      :ignored -> {:error, :node_unavailable}
    end
  end

  defp server_node do
    Application.get_env(:cineplex, :worker)[:server]
  end
end
