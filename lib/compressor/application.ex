defmodule Compressor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Compressor.Worker.start_link(arg)
      # {Compressor.Worker, arg},
      {Task.Supervisor, name: Compressor.TaskSupervisor},
      %{id: Exq, start: {Exq, :start_link, []}},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Compressor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
