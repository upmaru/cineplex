defmodule Compressor.Pipeline do
  alias Compressor.Queue.Job

  @callback task(Job.Entry.t()) :: any()
  @callback setting(Tesla.Client.t()) ::
              {:ok, %{presets: list(), storage: map()}} | {:error, :invalid_setting}

  @callback job(Tesla.Client.t()) ::
              {:ok, %{object: binary(), resource: binary(), events_callback_url: binary()}}
              | {:error, :invalid_job}

  @spec from_source(Source.t()) :: atom()
  def from_source(source) do
    Application.get_env(:compressor, :pipelines)[source.pipeline]
  end
end
