defmodule Compressor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @spec start(any(), any()) :: {:error, any()} | {:ok, pid()}
  def start(_type, _args) do
    role = Application.get_env(:compressor, :role)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Compressor.Supervisor]
    Supervisor.start_link(children(role), opts)
  end

  defp children("server") do
    [
      {Plug.Cowboy,
       scheme: :http, plug: CompressorWeb.Router, options: [port: 4000, compress: true]},
      # Starts a worker by calling: Compressor.Worker.start_link(arg)
      # {Compressor.Worker, arg},
      {Task.Supervisor, name: Compressor.TaskSupervisor},
      {Compressor.Repo, []},
      Compressor.Encode.Worker.Health,
      Compressor.Encode.Worker.Scheduler,
      Compressor.Queue.Job.Poller
    ]
  end

  defp children("worker") do
    [
      {Task.Supervisor, name: Compressor.TaskSupervisor},
      {Compressor.Repo, []},
      Compressor.Worker
    ]
  end
end
