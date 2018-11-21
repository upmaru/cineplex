defmodule Cineplex.Events do
  @moduledoc """
  Tracks all events emitted by the encoder
  """
  require Logger
  alias Cineplex.Current

  alias HTTPoison.Error

  defmodule Source do
    @moduledoc """
    Allows the Event to access the Resource with ease
    """
    use HTTPoison.Base

    def process_request_body(body), do: Poison.encode!(body)
  end

  def track(name, metadata \\ %{}) do
    Logger.info("[Cineplex] #{name}", event: %{"#{name}" => metadata})
    %{url: url, headers: headers} = Current.resource()

    case Source.post(url, %{"name" => name, "metadata" => metadata}, headers) do
      {:ok, _response} ->
        Logger.info("[Cineplex] #{name} tracked", event: %{"#{name}" => metadata})

      {:error, %Error{id: _, reason: reason}} ->
        Logger.info("[Cineplex] error_tracking #{reason}")
    end
  end
end
