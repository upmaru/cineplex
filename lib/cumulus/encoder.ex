defmodule Cumulus.Encoder do
  @moduledoc """
  Handles the encoding
  """
  alias Cumulus.Presets

  @behaviour Honeydew.Worker


  def perform(source_origin_url) do
    {:ok, file_path} = Download.from(source_origin_url)
  end
end