defmodule CliTest do
  use ExUnit.Case

  import ChuugWordCount.CLI

  test ":help returned by options -h and --help prints the help" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "--seed <url> returns correct value" do
    assert parse_args(["--seed", "/path/to/file"]) == {:seed, "/path/to/file"}
  end

  test "seed and report type" do
    assert parse_args(["--report", "full", "--seed", "/path/to/file" ]) == {:report, "full", :seed, "/path/to/file"}
  end

end
