defmodule Compressor.Adapter.UpmaruStudio.Job do
  use Compressor.Adapter.UpmaruStudio.Constants

  @behaviour Compressor.Adapter.Job

  alias Compressor.Adapter.UpmaruStudio.Connect

  @spec fetch() :: {:error, :invalid_request} | {:ok, {map(), <<_::264>>}}
  def fetch do
    case Connect.get("/v1/bot/compressor/media/jobs") do
      {:ok, %{body: body, status: 200}} -> {:ok, {body["data"]["attributes"], @url}}
      _ -> {:error, :invalid_request}
    end
  end

  def extract(job) do
    setting = setting(job)
  end

  defp setting(job) do
    case Connect.get(job.metadata["callbacks"]["settings_url"]) do
      {:ok, %{body: body, status: 200}} -> {:ok, {body}}
      _ -> {:error, :invalid_request}
    end
  end
end
