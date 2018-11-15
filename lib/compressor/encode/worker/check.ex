defmodule Compressor.Encode.Worker.Check do
  alias Compressor.{
    Repo, Encode
  }

  alias Encode.Worker

  @spec perform(%Worker{node_name: binary()}) :: :ok | {:ok, Worker.t()}
  def perform(worker) do
    case Node.ping(String.to_atom(worker.node_name)) do
      :pong -> :ok
      :pang -> mark_unavailable(worker)
    end
  end

  defp mark_unavailable(worker) do
    worker
    |> Worker.changeset(%{current_state: "unavailable"})
    |> Repo.update()
  end
end
