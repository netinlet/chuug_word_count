defmodule CliTest do
  use ExUnit.Case

  import ChuugWordCount.CLI

  test ":help returned by options -h and --help prints the help" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "--text <url> returns correct value" do
    assert parse_args(["--text", "http://google.com"]) == {:text, "http://google.com"}
  end

  test "process_response splits the response into an array of urls" do
    assert process_response({:ok, "http://google.com\nhttp://yahoo.com\n"}) == ["http://google.com", "http://yahoo.com"]
  end
end
