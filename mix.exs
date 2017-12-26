defmodule Compressor.Mixfile do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :compressor,
      version: "0.2.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      source_url: "https://github.com/upmaru/compressor",
      name: "Compressor",
      description: description(),
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [
        :logger,
        :ffmpex,
        :honeydew,
        :httpoison,
        :blazay
      ],
      mod: {Compressor.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ffmpex, "~> 0.4.1"},
      {:honeydew, "~> 1.0.4"},
      {:download, "~> 0.0.4"},
      {:blazay, "~> 1.2.0"},
      {:ex_doc, ">= 0.0.0", only: :dev}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp description do
    """
    Compressor is a distributed video compressor. It's designed to be used with Upmaru Studio
    """
  end

  defp package do
    [
      name: :compressor,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Zack Siri"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/upmaru/compressor"}
    ]
  end
end
