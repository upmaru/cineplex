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

  get "/health" do
    send_resp(conn, :ok, "ok")
  end

  post "/jobs" do
    %{source: source} = conn.assigns

    with {:ok, job} <- Queue.create_job(source, conn.body_params),
         {:ok, %{job: _job, entries: _entries}} <- Queue.Job.Extract.perform(job)
    do
      send_resp(conn, :created, "")
    else
      {:error, %Ecto.Changeset{changes: %{resource: resource}} = _changeset} ->
        job = Queue.get_job(resource: resource)
        Queue.Job.Extract.perform(job)
        send_resp(conn, :created, "")

      _ ->
        send_resp(conn, :unprocessable_entity, "")
    end
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
