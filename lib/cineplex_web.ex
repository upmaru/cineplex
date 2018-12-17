defmodule CineplexWeb do
  use Plug.Router

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(CineplexWeb.Plugs.Health)

  plug(Timber.Integrations.EventPlug)

  plug(:match)
  plug(:dispatch)

  forward("/jobs", to: CineplexWeb.Jobs)

  match _ do
    send_resp(conn, 404, "not found")
  end
end
