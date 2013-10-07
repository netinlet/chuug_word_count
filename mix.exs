defmodule ChuugWordCount.Mixfile do
  use Mix.Project

  def project do
    [ app: :chuug_word_count,
      version: "0.0.1",
      elixir: "~> 0.10.3",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [mod: { ChuugWordCount, [] }]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    []
  end
end
