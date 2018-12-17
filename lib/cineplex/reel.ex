defmodule Cineplex.Reel do
  alias Cineplex.Queue.Job

  @callback task(Job.Entry.t()) :: any()
  @callback track(Tesla.Client.t(), Job.t(), map) :: {:ok, :tracked} | {:error, :tracking_failed}
  @callback setting(Tesla.Client.t()) ::
              {:ok, %{presets: list(), storage: map()}} | {:error, :invalid_setting}

  @spec from_source(Source.t()) :: atom()
  def from_source(source) do
    Application.get_env(:cineplex, :reels)[source.reel]
  end
end
