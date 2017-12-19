defmodule Cumulus.Encoder do
  @moduledoc """
  Handles the encoding
  """
  alias Cumulus.Presets

  @behaviour Honeydew.Worker


  def perform(source_origin_url) do
    
  end

  defp download_source(url) do
    case HTTPoison.get(url, %{}, stream_to: self()) do
      {:ok, %HTTPoison.Response{statys_code: 200, body: body}} ->
    end
  end
end