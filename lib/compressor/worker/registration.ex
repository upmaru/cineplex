defmodule Compressor.Worker.Registration do
  alias Compressor.Encode

  require Logger

  @spec perform() :: {:error, Ecto.Changeset.t()} | {:ok, any()}
  def perform do
    with {:ok, _worker} <- Encode.register_worker(Atom.to_string(node()), "ready"),
         true <- Node.connect(server_node())
    do
      Logger.info("[Compressor.Worker.Registration] Successful")
      {:ok, :registered}
    else
      {:error, changeset} -> {:error, changeset}
      false -> {:error, :failed}
      :ignored -> {:error, :node_unavailable}
    end
  end


  defp server_node do
    Application.get_env(:compressor, :worker)[:server]
  end
end
