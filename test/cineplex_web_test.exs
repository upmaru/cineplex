defmodule CineplexWebTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias CineplexWeb

  import Cineplex.Factory

  @opts CineplexWeb.init([])

  @params %{
    object: "some/object.mov",
    resource: "some/resource:1",
    events_callback_url: "https://example.com/media/1/events"
  }

  @source "https://example.com"
  @mimetype "application/json"

  setup_all do
    source = insert(:source)

    {:ok, %{source: source}}
  end

  describe "unauthorized" do
    test "get /health" do
      conn =
        conn(:get, "/health")
        |> CineplexWeb.call(@opts)

      assert conn.status == 200
    end

    test "post /jobs" do
      conn =
        conn(:post, "/jobs", @params)
        |> put_req_header("content-type", @mimetype)
        |> CineplexWeb.call(@opts)

      assert conn.status == 401
    end
  end

  describe "authorized" do
    test "post /jobs" do
      conn =
        conn(:post, "/jobs", @params)
        |> put_req_header("content-type", @mimetype)
        |> put_req_header("x-source", @source)
        |> CineplexWeb.call(@opts)

      assert conn.status == 201
    end

    test "post /jobs retry", %{source: source} do
      insert(:job, resource: "existing/resource:2", source: source)

      params = %{
        object: "some/object.mov",
        resource: "existing/resource:2",
        events_callback_url: "https://example.com/media/2/events"
      }

      conn =
        conn(:post, "/jobs", params)
        |> put_req_header("content-type", @mimetype)
        |> put_req_header("x-source", @source)
        |> CineplexWeb.call(@opts)

      assert conn.status == 201
    end
  end
end
