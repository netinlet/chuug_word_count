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
      { [ report: report_type, seed: url], _, _ }  -> {:report, report_type, :seed, url}
      { [ seed: url], _, _ }    -> {:seed, url}
      _                        -> :help
    end
  end

  def process(:help) do
    IO.puts """
      Usage: chuug_word_count --report <full> || <summary>  --seed <url>
    """
  end

  def process({:seed, url}) do
    process({:report, "summary", :seed, url})
  end

  def process({:report, report_type, :seed, url}) do
    IO.puts "~~~~~ Fetching #{url}"
    word_counts = ChuugWordCount.UrlHelper.fetch(url)
      |> extract_seed_urls
      |> word_count_docs
      |> sort_results

    print(report_type, word_counts)
  end

  defp extract_seed_urls({:ok, body}) do
    String.split(body, "\n", trim: true)
  end

  defp extract_seed_urls({:error, msg}) do
    IO.puts "Error retrieving seed data"
    System.halt(2)
  end

  def word_count_docs(seed_urls) do
    ChuugWordCount.WordCounter.tally(seed_urls)
  end

  def sort_results(word_count_dict) do
    Enum.sort(word_count_dict, fn({a,av},{b,bv}) ->
      av > bv
    end)
  end

  def print("summary", sorted_wc) do
    print("total_wc", sorted_wc)
    print("top", 10, sorted_wc)
    print("bottom", 10, sorted_wc)
  end

  def print("full", list) do
    IO.puts "========================================"
    IO.puts "All Word Frequency"
    Enum.each(list, fn({word, word_count}) -> IO.puts "#{word} : #{word_count}" end)
  end

  def print("total_wc", sorted_wc) do
    IO.puts "========================================"
    IO.puts "Found #{Enum.count(sorted_wc)} words\n"
  end

  def print("top", count, list) do
    IO.puts "========================================"
    IO.puts "CHUUG Elixir Top 10 most frequent words"
    Enum.take(list, count)
      |> Enum.each(fn({word, word_count}) -> IO.puts "#{word} : #{word_count}" end)

   IO.puts "\n"
  end

  def print("bottom", count, list) do
    IO.puts "========================================"
    IO.puts "CHUUG Elixir Top 10 least frequent words"
    Enum.slice(list, Enum.count(list) - count, Enum.count(list) - 1)
      |> Enum.each(fn({word, word_count}) -> IO.puts "#{word} : #{word_count}" end)

    IO.puts "\n"
  end

end
