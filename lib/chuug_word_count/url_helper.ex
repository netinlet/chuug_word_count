defmodule ChuugWordCount.UrlHelper do

  def fetch(url) do
    case HTTPotion.get(url) do
      HTTPotion.Response[body: body, status_code: status, headers: _headers]
      when status in 200..299 ->
        {:ok, body}
      HTTPotion.Response[body: body, status_code: _status, headers: _headers] ->
        {:error, body}
    end
  end

end
