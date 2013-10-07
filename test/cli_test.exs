defmodule CliTest do
  use ExUnit.Case

  import ChuugWordCount.CLI, only: [ parse_args: 1 ]

  test ":help returned by options -h and --help prints the help" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end
end
