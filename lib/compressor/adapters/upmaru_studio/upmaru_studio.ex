defmodule Compressor.Adapters.UpmaruStudio do
  def client(endpoint, token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, endpoint},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"authorization", "Bearer " <> token}]}
    ]

    Tesla.client(middleware)
  end

  @spec job(Tesla.Client.t()) :: {:ok, map} | {:error, :invalid_job}
  def job(client) do
    case Tesla.get(client, "/v1/bot/compressor/media/jobs") do
      {:ok, %{body: body, status: 200}} -> {:ok, body["data"]["attributes"]}
      _ -> {:error, :invalid_job}
    end
  end

  @spec setting(Tesla.Client.t()) ::
          {:ok, %{presets: list(), storage: map()}} | {:error, :invalid_setting}
  def setting(client) do
    case Tesla.get(client, "/v1/bot/compressor/settings") do
      {:ok, %{body: body, status: 200}} ->
        {:ok, %{presets: body["data"]["presets"], storage: body["data"]["storage"]}}

      _ ->
        {:error, :invalid_setting}
    end
  end
end
