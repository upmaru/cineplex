defmodule CineplexWeb do
  use Plug.Router

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(Timber.Integrations.EventPlug)

  plug(:match)
  plug(:dispatch)

  get "/health" do
    send_resp(conn, :ok, "ok")
  end

  forward("/jobs", to: CineplexWeb.Jobs)

  match _ do
    send_resp(conn, 404, "not found")
  end
end
