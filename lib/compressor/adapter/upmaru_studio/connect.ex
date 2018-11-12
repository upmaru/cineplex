defmodule Compressor.Adapter.UpmaruStudio.Connect do
  use Tesla
  use Compressor.Adapter.UpmaruStudio.Constants

  plug(Tesla.Middleware.BaseUrl, @url)
  plug(Tesla.Middleware.Headers, [{"authorization", "Bearer " <> @token}])
  plug(Tesla.Middleware.JSON)
end
