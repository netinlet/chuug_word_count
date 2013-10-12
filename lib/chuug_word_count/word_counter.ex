defmodule ChuugWordCount.WordCounter do

  def tally(urls) do
    IO.puts "Tallying..."
    fetch_all(urls)
      |> count
      |> print_summary
  end

  def fetch_all(urls) do
    pmap(urls, fn(url) ->
      IO.puts "Fetching #{url}"
      {_, body} = ChuugWordCount.UrlHelper.fetch(url)
      body
    end)
  end

  def print_summary(word_count_dict) do
    sorted_wc = Enum.sort(word_count_dict, fn({a,av},{b,bv}) ->
      av > bv
    end)
    print(:summary, sorted_wc)
    print(:top, 10, sorted_wc)
    print(:bottom, 10, sorted_wc)
  end

 def count(docs) do
   IO.puts "Counting..."
    pmap(docs, fn(doc) ->
      IO.puts "Mapping Doc..."
      doc
        |> String.downcase
        |> to_words
    end)
      |> List.flatten
      |> summarize
  end

  def print(:summary, list) do
    IO.puts "========================================"
    IO.puts "Found #{Enum.count(list)} words\n"
  end

  def print(:top, count, list) do
    IO.puts "========================================"
    IO.puts "CHUUG Elixir Top 10 most frequent words"
    Enum.take(list, count)
      |> Enum.each(fn({word, word_count}) -> IO.puts "#{word} : #{word_count}" end)

   IO.puts "\n"
  end

  def print(:bottom, count, list) do
    IO.puts "========================================"
    IO.puts "CHUUG Elixir Top 10 least frequent words"
    Enum.slice(list, Enum.count(list) - count, Enum.count(list) - 1)
      |> Enum.each(fn({word, word_count}) -> IO.puts "#{word} : #{word_count}" end)

    IO.puts "\n"
  end

  defp to_words(sentence), do: List.flatten Regex.scan(%r{\w+}, sentence)

  defp summarize(words) do
    IO.puts "Summarizing..."
    Enum.reduce words, HashDict.new, add_count(&1, &2)
  end

  defp add_count(word, counts) do
    HashDict.update counts, word, 1, &1 + 1
  end

  defp pmap(collection, fun) do
    me = self

    collection
    |>
    Enum.map(fn (elem) ->
      spawn_link fn -> (me <- { self, fun.(elem) }) end
    end)
    |> Enum.map(fn (pid) ->
      receive do { pid, result } -> result end
    end)
  end

end

