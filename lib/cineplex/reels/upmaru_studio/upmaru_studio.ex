defmodule Cineplex.Reels.UpmaruStudio do
  @behaviour Cineplex.Reel

  alias Cineplex.Queue.Job
  alias Cineplex.Reels.UpmaruStudio

  @spec task(Job.Entry.t()) :: any()
  def task(job_entry), do: UpmaruStudio.Encode.perform(job_entry)

  @spec client(any(), binary()) :: Tesla.Client.t()
  def client(endpoint, token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, endpoint},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"authorization", "Bearer " <> token}]}
    ]

    Tesla.client(middleware)
  end

  @spec job(Tesla.Client.t()) ::
          {:ok, %{object: binary, resource: binary, events_callback_url: binary}}
          | {:error, :invalid_job}
  def job(client) do
    case Tesla.get(client, "/v1/bot/cineplex/media/jobs") do
      {:ok, %{body: body, status: 200}} ->
        job = body["data"]["attributes"]

        {:ok,
         %{
           object: job["object"],
           resource: job["resource"],
           events_callback_url: job["events_callback_url"]
         }}

      _ ->
        {:error, :invalid_job}
    end
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
