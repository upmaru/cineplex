defmodule Compressor.Encode do
  alias Compressor.{
    Encode,
    Repo
  }

  @spec register_worker(binary(), binary()) ::
          {:ok, Encode.Worker.t()} | {:error, Ecto.Changeset.t()}
  def register_worker(node_name, state) do
    case Repo.get_by(Encode.Worker, node_name: node_name) do
      nil -> %Encode.Worker{node_name: node_name}
      worker -> worker
    end
    |> Encode.Worker.changeset(%{current_state: state})
    |> Repo.insert_or_update()
  end
end
