defmodule Cumulus.Encoder do
  @moduledoc """
  Handles the encoding
  """
  alias Cumulus.Presets

  @behaviour Honeydew.Worker

  def perform(source_origin_url) do
    with {:ok, file_path} <- Download.from(source_origin_url),
  end

  defp encode(file_path) do
    presets = Application.get_env(:cumulus, :presets)
  end
end