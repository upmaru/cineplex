defmodule Compressor.Adapter.Job do
  alias Compressor.Queue.Job

  @callback fetch() :: {:ok, {map, binary}} | {:error, :invalid_request}
  @callback extract(Job.t()) :: {:ok, list()} | {:error, :extraction_failed}
end
