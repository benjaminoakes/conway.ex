Code.require_file("u.ex", "lib")
Code.require_file("test_helper.ex", "lib")
Code.require_file("cell.ex", "lib/conway")
Code.require_file("cell_test_suite.ex", "lib/conway")
Code.require_file("grid.ex", "lib/conway")
Code.require_file("grid_test_suite.ex", "lib/conway")
Code.require_file("test_suite.ex", "lib/conway")

defmodule Conway.CLI do
  alias Conway.Grid

  def main(["--help"]), do: show_usage
  def main(["--test"]), do: Conway.TestSuite.run_all
  def main([_, _, _] = argv) do
    parsed = Enum.map(argv, fn (string) ->
      { integer, _ } = Integer.parse(string)
      integer
    end)

    start(parsed)
  end
  def main(_), do: show_usage

  def start([ width, height, generations_count ]) do
    :random.seed(:os.timestamp)
    initial_grid = Grid.generate(width, height)

    Grid.step(initial_grid, generations_count, fn (grid) ->
      IO.puts(Grid.displayable(grid))
    end)
  end

  def show_usage do
    text = [
      "Usage: conway width height generations",
      "",
      "Runs a simulation of Conway's Game of Life",
      "",
      "More information: https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life",
      "",
      "    --help  Show this help text",
      "    --test  Run automated tests"
    ]

    IO.puts(Enum.join(text, "\n"))
  end
end

Conway.CLI.main(System.argv)
