defmodule Cineplex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @spec start(any(), any()) :: {:error, any()} | {:ok, pid()}
  def start(_type, _args) do
    role = Application.get_env(:cineplex, :role)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cineplex.Supervisor]
    Supervisor.start_link(children(role), opts)
  end

  defp children("server") do
    [
      {Plug.Cowboy,
       scheme: :http, plug: CineplexWeb.Router, options: [port: 4000, compress: true]},
      # Starts a worker by calling: Cineplex.Worker.start_link(arg)
      # {Cineplex.Worker, arg},
      {Task.Supervisor, name: Cineplex.TaskSupervisor},
      {Cineplex.Repo, []},
      Cineplex.Distribution.Worker.Health,
      Cineplex.Distribution.Worker.Scheduler,
      Cineplex.Queue.Job.Poller
    ]
  end

  defp children("worker") do
    [
      {Task.Supervisor, name: Cineplex.TaskSupervisor},
      {Cineplex.Repo, []},
      Cineplex.Worker
    ]
  end
end
