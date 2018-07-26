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
      source_url: "https://github.com/tyrchen/utility_belt",
      homepage_url: "https://github.com/tyrchen/utility_belt",
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
      {:cipher, "~> 1.4.0"},
      {:ecto, "~> 2.1"},
      {:not_qwerty123, "~> 2.3"},
      {:recase, "~> 0.3.0"},

      # joken related
      {:joken, "~> 1.1"},
      {:libsodium, "> 0.0.0"},
      {:keccakf1600, "> 0.0.0"},
      # {:libdecaf, "> 0.0.0"},

      # comeonin related
      {:comeonin, "~> 4.0"},
      {:argon2_elixir, "~> 1.2"},
      {:bcrypt_elixir, "~> 1.0"},

      # Normal
      {:con_cache, "~> 0.13.0"},
      {:ex_datadog_plug, "~> 0.5.0"},

      # deployment
      {:distillery, "~> 1.5", runtime: false},

      # dev & test
      {:credo, "~> 0.8", only: [:dev, :test]},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.18.0", only: [:dev, :test]},
      {:pre_commit_hook, "~> 1.2", only: [:dev, :test]},

      # test only
      {:faker, "~> 0.10", only: [:dev, :test]},
      {:ex_machina, "~> 2.2", only: [:dev, :test]},
      {:mock, "~> 0.3.1", only: [:dev, :test]}
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
        "LICENSE*",
        "version",
        ".elixir_version",
        ".otp_version"
      ],
      licenses: ["MIT"],
      maintainers: ["tyr.chen@gmail.com"],
      links: %{
        "GitHub" => "https://github.com/tyrchen/utility_belt",
        "Docs" => "https://hexdocs.pm/utility_belt"
      }
    ]
  end
end
