defmodule ChuugWordCount.CLI do

  def run(argv) do
    parse_args(argv)
  end

  def parse_args(argv)  do
    opts = OptionParser.parse(argv, switches: [ help: :boolean],
                                    aliases:  [ h:  :help])

    case opts do
      { [ help: true ], _, _ }    -> :help
      { [ text: url], _, _ }    -> {:text, url}
      _                        -> :help
    end
  end

end
