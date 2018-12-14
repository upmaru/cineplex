defmodule CineplexWeb.Router do
  use Plug.Router

  alias Cineplex.Queue

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(CineplexWeb.AuthorizePlug)

  plug(:match)
  plug(:dispatch)

  post "/jobs" do
    %{source: source} = conn.assigns

    case Queue.create_job(source, conn.body_params) do
      {:ok, job} ->
        Queue.Job.Extract.perform(job)

      _ ->
        conn
        |> send_resp(:unprocessable_entity, "")
    end
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
