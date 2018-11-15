defmodule Compressor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @spec start(any(), any()) :: {:error, any()} | {:ok, pid()}
  def start(_type, _args) do
    role = Application.get_env(:compressor, :role)
    # List all child processes to be supervised
    children = %{
      "server" => [
        {Plug.Cowboy,
         scheme: :http, plug: CompressorWeb.Router, options: [port: 4000, compress: true]},
        # Starts a worker by calling: Compressor.Worker.start_link(arg)
        # {Compressor.Worker, arg},
        {Task.Supervisor, name: Compressor.TaskSupervisor},
        {Compressor.Repo, []},
        Compressor.Encode.Worker.Health,
        Compressor.Queue.Job.Poller
      ],
      "worker" => [
        {Compressor.Repo, []},
        Compressor.Worker
      ]
    }

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Compressor.Supervisor]
    Supervisor.start_link(children[role], opts)
  end
end
