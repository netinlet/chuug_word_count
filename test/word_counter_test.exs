defmodule WordCountTest do
  use ExUnit.Case

  import ChuugWordCount.WordCounter

  test "count one word" do
    assert ChuugWordCount.WordCounter.count(["foo"]) == HashDict.new([{"foo", 1}])
  end

  test "count three distinct words" do
    assert ChuugWordCount.WordCounter.count(["foo bar baz"]) == HashDict.new([{"foo", 1}, {"bar", 1}, {"baz", 1}])
  end

  test "multiple words" do
    assert ChuugWordCount.WordCounter.count(["three one two three two three"]) == HashDict.new([{"one", 1}, {"two", 2}, {"three", 3}])
  end

  test "handles string input" do
    assert ChuugWordCount.WordCounter.count("one two three") == HashDict.new([{"one", 1}, {"two", 1}, {"three", 1}])
  end

  test "multi line documents" do
    input = """
    one
    two two
    three three three
    four four four four
    five five five five five
    six six six six six six
    seven seven seven seven seven seven seven
    eight eight eight eight eight eight eight eight
    nine nine nine nine nine nine nine nine nine
    ten ten ten ten ten ten ten ten ten ten
    """

    assert ChuugWordCount.WordCounter.count([input]) == HashDict.new([{"one", 1}, {"two", 2}, {"three", 3}, {"four", 4}, {"five", 5},
                                                                    {"six", 6}, {"seven", 7}, {"eight", 8}, {"nine", 9}, {"ten", 10}])
  end

  test "handling punctuation" do
    assert ChuugWordCount.WordCounter.count("I didn't get a harrumph out of that guy!") == HashDict.new( [{"i", 1}, {"didn't", 1}, {"get", 1},
                                                                                                         {"a", 1}, {"harrumph", 1}, {"out", 1},
                                                                                                         {"of", 1}, {"that", 1}, {"guy", 1}])
  end


end
