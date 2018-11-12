defmodule Compressor.Extract do
  @adapter %{
    "https://api.upmaru.studio" => Compressor.Extract.Sources.UpmaruStudio,
    "https://staging.api.upmaru.studio" => Compressor.Extract.Sources.UpmaruStudio
  }

  def perform(job) do
  end
end
