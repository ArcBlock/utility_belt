defmodule UtilityBelt.MixProject do
  use Mix.Project

  @version File.cwd!() |> Path.join("version") |> File.read!() |> String.trim()
  @elixir_version File.cwd!() |> Path.join(".elixir_version") |> File.read!() |> String.trim()
  @otp_version File.cwd!() |> Path.join(".otp_version") |> File.read!() |> String.trim()

  def get_version, do: @version
  def get_elixir_version, do: @elixir_version
  def get_otp_version, do: @otp_version

  def project do
    [
      app: :utility_belt,
      version: @version,
      elixir: @elixir_version,
      description: description(),
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),

      # Docs
      name: "UtilityBelt",
      source_url: "https://github.com/ArcBlock/utility_belt",
      homepage_url: "https://github.com/ArcBlock/utility_belt",
      docs: [
        main: "UtilityBelt",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {UtilityBelt.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:cipher, "~> 1.4", optional: true},
      {:ecto, "~> 3.0"},
      {:ecto_sql, "~> 3.0", optional: true},
      {:postgrex, "~> 0.14", optional: true},
      {:not_qwerty123, "~> 2.3", optional: true},
      {:recase, "~> 0.4.0", optional: true},

      # joken related
      {:joken, "~> 1.5", optional: true},

      # comeonin related
      {:comeonin, "~> 4.1", optional: true},
      {:argon2_elixir, "~> 1.3", optional: true},
      {:bcrypt_elixir, "~> 1.1", optional: true},

      # Normal
      {:con_cache, "~> 0.13.0"},
      {:ex_datadog_plug, "~> 0.5.0", optional: true},
      {:plug, "~> 1.7", optional: true, optional: true},

      # dev & test
      {:credo, "~> 1.0", only: [:dev, :test], optional: true},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false, optional: true},
      {:ex_doc, "~> 0.19", only: [:dev, :test], optional: true},
      {:pre_commit_hook, "~> 1.2", only: [:dev, :test], optional: true},

      # test only
      {:faker, "~> 0.11", only: [:dev, :test]},
      {:ex_machina, "~> 2.2.2", only: [:dev, :test], optional: true},
      {:mock, "~> 0.3", only: [:dev, :test], optional: true},
      {:coveralls, "~> 1.5", only: [:test], optional: true}
    ]
  end

  defp description do
    """
    A set of utility functions / macros.
    """
  end

  defp package do
    [
      files: [
        "config",
        "lib",
        "mix.exs",
        "README*",
        "version",
        ".elixir_version",
        ".otp_version"
      ],
      licenses: ["MIT"],
      maintainers: ["tyr.chen@gmail.com"],
      links: %{
        "GitHub" => "https://github.com/ArcBlock/utility_belt",
        "Docs" => "https://hexdocs.pm/utility_belt"
      }
    ]
  end
end
