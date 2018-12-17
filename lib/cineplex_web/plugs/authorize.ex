defmodule CineplexWeb.Plugs.Authorize do
  import Plug.Conn

  alias Cineplex.Queue
  alias Queue.Source

  @spec init(any()) :: any()
  def init(options), do: options

  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(conn, _options) do
    with %{"x-source" => endpoint} <- Enum.into(conn.req_headers, %{}),
         %Source{} = source <- Queue.get_source(endpoint: endpoint)
    do
      assign(conn, :source, source)
    else
      _ -> handle_not_authorized(conn)
    end
  end

  defp handle_not_authorized(conn) do
    conn
    |> send_resp(:unauthorized, "not authorized")
    |> halt()
  end
end
