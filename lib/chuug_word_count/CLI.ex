defmodule ChuugWordCount.CLI do

  def run(argv) do
    parse_args(argv)
     |> process
  end

  def parse_args(argv) do
    opts = OptionParser.parse(argv, switches: [ help: :boolean],
                                    aliases:  [ h:  :help])
    case opts do
      { [ help: true ], _, _ }    -> :help
      { [ text: url], _, _ }    -> {:text, url}
      _                        -> :help
    end
  end

  def process(:help) do
    IO.puts """
      Usage: chuug_word_count --text <url>
    """
  end

  def process({:text, url}) do
    IO.puts "~~~~~ Fetching #{url}"
    ChuugWordCount.UrlHelper.fetch(url)
      |> process_response
  end

  def process_response({:ok, body}) do
    String.split(body, "\n", trim: true)
      |> ChuugWordCount.WordCounter.tally
  end

  def process_response({:error, msg}) do
    IO.puts "Error retrieving seed data"
    System.halt(2)
  end





end
