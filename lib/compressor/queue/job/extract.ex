defmodule Compressor.Queue.Job.Extract do
  alias Compressor.Queue.Job

  @spec perform(Job.t()) :: {:error, Ecto.Changeset.t()} | {:ok, Job.t()}
  def perform(%Job{source: source} = job) do
    # Enum.map(source.presets, fn preset ->
    #   %Entry{job: job}
    # end)

    # with {:ok, %{presets: presets, storage: storage}} <- module.extract(job) do
    #      {:ok, job}
    # else

    # end
  end

  def entry_from_preset(preset) do
  end
end
