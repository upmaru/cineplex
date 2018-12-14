defmodule CineplexWeb.AuthorizePlug do
  import Plug.Conn

  alias Cineplex.Queue
  alias Queue.Source

  @spec init(any()) :: any()
  def init(options), do: options

  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(conn, _options) do
    case Queue.get_source(endpoint: conn.host) do
      %Source{} = source ->
        assign(conn, :source, source)

      nil ->
        handle_not_authorized(conn)
    end
  end

  defp handle_not_authorized(conn) do
    conn
    |> send_resp(:unauthorized, "not authorized")
    |> halt()
  end
end
