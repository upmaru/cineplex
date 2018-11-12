defmodule Compressor.Extract.Sources.UpmaruStudio do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, Compressor.source(:url))
  plug(Tesla.Middleware.Headers, [{"authorization", "Bearer " <> Compressor.source(:token)}])
  plug(Tesla.Middleware.JSON)

  def perform(job) do
  end

  def entries do
  end

  def settings(job) do
    get(job.metadata["callbacks"]["settings_url"])
  end
end
