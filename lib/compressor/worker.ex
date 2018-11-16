defmodule Compressor.Worker do
  @moduledoc """
  This GenServer is started on the Worker node and registers
  itself into the pool of workers.
  """

  use GenServer

  alias Compressor.Worker.{
    Begin,
    Finish,
    Registration
  }

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def perform(job_entry) do
    GenServer.call(__MODULE__, {:perform, job_entry}, :infinity)
  end

  # Callbacks

  @impl true
  @spec init(any()) :: {:ok, nil}
  def init(_) do
    Registration.perform()
    {:ok, nil}
  end

  @impl true
  def handle_call({:perform, job_entry}, _from, state) do
    {:reply, Begin.perform(job_entry), state}
  after
    Finish.perform(job_entry)
  end
end
