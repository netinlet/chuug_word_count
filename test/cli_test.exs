defmodule CliTest do
  use ExUnit.Case

  import ChuugWordCount.CLI

  test ":help returned by options -h and --help prints the help" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "--seed <url> returns correct value" do
    assert parse_args(["--seed", "http://google.com"]) == {:seed, "http://google.com"}
  end

  test "seed and report type" do
    assert parse_args(["--report", "full", "--seed", "http://google.com" ]) == {:report, "full", :seed, "http://google.com"}
  end

end
