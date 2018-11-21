defmodule Cineplex.Distribution.Node.Check do
  alias Cineplex.{
    Repo,
    Distribution
  }


  @spec perform(%Distribution.Node{name: binary()}) :: :ok | {:ok, Distribution.Node.t()}
  def perform(node) do
    case Node.ping(String.to_atom(node.name)) do
      :pong -> :ok
      :pang -> mark_unavailable(node)
    end
  end

  defp mark_unavailable(node) do
    node
    |> Distribution.Node.changeset(%{current_state: "unavailable"})
    |> Repo.update()
  end
end
