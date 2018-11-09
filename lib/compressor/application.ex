defmodule Compressor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @spec start(any(), any()) :: {:error, any()} | {:ok, pid()}
  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Plug.Cowboy, scheme: :http, plug: Compressor.Router, options: [port: 4001, compress: true]},
      # Starts a worker by calling: Compressor.Worker.start_link(arg)
      # {Compressor.Worker, arg},
      {Task.Supervisor, name: Compressor.TaskSupervisor},
      {Compressor.Repo, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Compressor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
