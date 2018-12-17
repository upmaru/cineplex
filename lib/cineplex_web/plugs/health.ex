defmodule CineplexWeb.Plugs.Health do
  import Plug.Conn

  @spec init(any()) :: any()
  def init(options), do: options

  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(%{request_path: "/health"} = conn, _opts) do
    Appsignal.Transaction.set_action("GET /health")

    conn
    |> send_resp(:ok, "we're good!")
    |> halt()
  end

  def call(conn, _opts), do: conn
end
