defmodule ChuugWordCount.CLI do

  def run(argv) do
    parse_args(argv)
     |> process
  end

  def parse_args(argv) do
    opts = OptionParser.parse(argv, switches: [ help: :boolean],
                                    aliases:  [ h:  :help])
    case opts do
      { [ help: true ], _, _ }                      -> :help
      { [ report: report_type, seed: path], _, _ }  -> {:report, report_type, :seed, path}
      { [ seed: path], _, _ }                       -> {:seed, path}
      _                                             -> :help
    end
  end

  def process(:help) do
    IO.puts """
      Usage: chuug_word_count --report <full> || <summary>  --seed <url>
    """
  end

  def process({:seed, path}) do
    process({:report, "summary", :seed, path})
  end

  def process({:report, report_type, :seed, path}) do
    word_counts = read_seed(path)
      |> extract_seed_urls
      |> word_count_docs
      |> sort_results

    print(report_type, word_counts)
  end

  def read_seed(path) do
    File.read(path)
  end


  defp extract_seed_urls({:ok, body}) do
    String.split(body, "\n", trim: true)
  end

  defp extract_seed_urls({:error, msg}) do
    IO.puts "Error retrieving seed data: #{msg}"
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
    print("total_unique", sorted_wc)
    print("total_wc", sorted_wc)
    print("top", 10, sorted_wc)
    print("bottom", 10, sorted_wc)
  end

  def print("full", list) do
    IO.puts "========================================"
    IO.puts "All Word Frequency"
    Enum.each(list, fn({word, word_count}) -> IO.puts "#{word} : #{word_count}" end)
  end

  def print("total_unique", sorted_wc) do
    IO.puts "========================================"
    total = Enum.reduce(sorted_wc, 0, fn({_, word_frequency}, acc) ->  acc + word_frequency end)

    IO.puts "Found #{total} TOTAL words\n"
  end

  def print("total_wc", sorted_wc) do
    IO.puts "========================================"
    IO.puts "Found #{Enum.count(sorted_wc)} UNIQUE words\n"
  end

  def print("top", count, list) do
    IO.puts "========================================"
    IO.puts "CHUUG Elixir Top 10 most frequent words"
    Enum.take(list, count)
      |> Enum.each(fn({word, word_count}) when is_binary(word) -> # without the with_binary check, this errors due to elixir bug - sometimes residual process laying around from compilation
           IO.puts "#{word} : #{word_count}"
         end)

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
