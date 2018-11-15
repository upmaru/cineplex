defmodule Compressor.Worker do
  @moduledoc """
  This GenServer is started on the Worker node and registers
  itself into the pool of workers.
  """

  use GenServer

  alias Compressor.Worker.Registration

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  @spec init(any()) :: {:ok, nil}
  def init(_) do
    Registration.perform()
    {:ok, nil}
  end
end
