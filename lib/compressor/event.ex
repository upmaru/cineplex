defmodule Compressor.Event do
  @moduledoc """
  Tracks all events emitted by the encoder
  """
  use Agent

  defmodule Source do
    @moduledoc """
    Allows the Event to access the Resource with ease
    """
    use HTTPoison.Base

    def process_request_body(body) do
      Poison.encode!(%{
        encoding_events: body
      })
    end

    def process_response_body(body) do
      {:ok, body} = Poison.decode(body)
      body["data"]["encoding_events"]
    end
  end

  def start_link do
    Agent.start_link(fn ->
      %{url: url, headers: headers} = Current.resource

      Source.get!(url, headers)
    end, name: __MODULE__)
  end

  def all do
    Agent.get(__MODULE__, fn events -> events end)
  end

  def track(name) do
    Agent.update(__MODULE__, fn existing_events ->
      %{url: url, headers: headers} = Current.resource

      Source.patch!(url, [%{"name" => name} | existing_events], headers)
    end)
  end
end
