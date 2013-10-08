defmodule UrlHelperTest do
  use ExUnit.Case

  import ChuugWordCount.UrlHelper

  test "can retrieve the contents of a url" do
    assert fetch("http://netinlet.com/assets/chuug.txt") == {:ok, "Hello Chuug!\n"}
  end
end

