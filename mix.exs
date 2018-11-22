defmodule Compressor.Mixfile do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :cineplex,
      version: "0.8.0",
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/upmaru/complex",
      name: "Complex",
      description: description(),
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [
        :timber,
        :logger,
        :ffmpex,
        :httpoison,
        :upstream,
        :plug_cowboy,
        :plug,
        :parse_trans,
        :downstream
      ],
      mod: {Cineplex.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # ffmpeg
      {:ffmpex, "~> 0.5.2"},

      # for transfer
      {:downstream, "~> 0.1.0"},
      {:upstream, "~> 1.7.0"},
      {:jason, ">= 1.0.0"},

      # http client
      {:tesla, "~> 1.2.0"},
      {:hackney, "~> 1.14.0"},

      # web
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:jsonapi, "~> 0.8.0"},

      # database
      {:ecto_sql, "~> 3.0"},
      {:ecto, "~> 3.0", override: true},
      {:postgrex, "~> 0.14.0"},

      # logging
      {:timber, "~> 2.8"},

      # deployment
      {:distillery, "~> 1.5", runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp description do
    """
    Cineplex is a distributed video worker. It's designed to be used with Upmaru Studio
    """
  end

  defp package do
    [
      name: :cineplex,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Zack Siri"],
      licenses: ["MIT"],
      links: %{"GitLab" => "https://gitlab.com/upmaru/cineplex"}
    ]
  end
end
