defmodule Cineplex.Reels.UpmaruStudio do
  @behaviour Cineplex.Reel

  alias Cineplex.Queue.Job
  alias Cineplex.Reels.UpmaruStudio

  @spec task(Job.Entry.t()) :: any()
  def task(job_entry), do: UpmaruStudio.Encode.perform(job_entry)

  @spec track(Tesla.Client.t(), Job.t(), map) :: {:ok, :tracked} | {:error, :tracking_failed}
  def track(client, %Job{events_callback_url: url} = _job, data) do
    case Tesla.post(client, url, data) do
      {:ok, %{body: _body, status: 201}} -> {:ok, :tracked}
      _ -> {:error, :tracking_failed}
    end
  end

  @spec client(any(), binary()) :: Tesla.Client.t()
  def client(endpoint, token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, endpoint},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"authorization", "Bearer " <> token}]}
    ]

    Tesla.client(middleware)
  end

  @spec setting(Tesla.Client.t()) ::
          {:ok, %{presets: list(), storage: map()}} | {:error, :invalid_setting}
  def setting(client) do
    case Tesla.get(client, "/v1/bot/cineplex/settings") do
      {:ok, %{body: body, status: 200}} ->
        {:ok, %{presets: body["data"]["presets"], storage: body["data"]["storage"]}}

      _ ->
        {:error, :invalid_setting}
    end
  end
end
