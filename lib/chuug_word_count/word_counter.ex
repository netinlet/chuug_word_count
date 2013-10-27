defmodule ChuugWordCount.WordCounter do

  def tally(urls) do
    fetch_all(urls)
      |> count
  end

  def fetch_all(urls) do
    pmap(urls, fn(url) ->
      {_, body} = ChuugWordCount.UrlHelper.fetch(url)
      body
    end)
  end

 def count(doc) when is_binary(doc) do
   count([doc])
 end

 def count(docs) when is_list(docs) do
   pmap(docs, fn(doc) ->
     doc
       |> to_words
       |> List.flatten
       |> summarize
   end)
     |> merge_summaries
 end

 def merge_summaries(word_count_summaries) do
   Enum.reduce(word_count_summaries, HashDict.new, fn(wc_dict, accum) ->
     Enum.reduce(HashDict.keys(wc_dict), accum, fn(word, master_dict) ->
       HashDict.put(master_dict, word, HashDict.get(master_dict, word, 0) + HashDict.get(wc_dict, word))
     end)
   end)
 end

  defp to_words(doc) do
    String.split(doc) |> Enum.map(fn(word) -> Regex.replace(%r/\W$/, word, "") end)
  end

  defp summarize(words) do
    Enum.reduce(words, HashDict.new, fn(word,acc) ->
      add_count(String.downcase(word), acc)
    end)
  end

  defp add_count(word, counts) do
    HashDict.update(counts, word, 1, fn(val) ->
      val + 1
    end)
  end

  defp pmap(collection, fun) do
    me = self

    collection
      |>
      Enum.map(fn (elem) ->
        spawn_link fn -> (me <- { self, fun.(elem) }) end
      end)
      |>
      Enum.map(fn (pid) ->
        receive do { pid, result } -> result end
      end)
  end

end

