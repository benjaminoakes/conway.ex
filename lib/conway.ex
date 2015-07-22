Code.require_file("u.ex", "lib")

defmodule TestHelper do
  def assert(condition) do
    if !condition do
      raise "assert failed"
    end
  end
end

defmodule Conway.Cell do
  def generate do
    if :random.uniform > 0.5 do
      1
    else
      0
    end
  end

  def displayable(cell) do
    if 1 == cell do
      "•"
    else
      " "
    end
  end

  def maybe(cell) do
    if cell do
      cell
    else
      0
    end
  end

  # Rules:
  #
  #   * Any live cell with fewer than two live neighbours dies, as if caused
  #     by under-population.
  #   * Any live cell with two or three live neighbours lives on to the next 
  #     generation.
  #   * Any live cell with more than three live neighbours dies, as if by 
  #     overcrowding.
  #   * Any dead cell with exactly three live neighbours becomes a live cell,
  #     as if by reproduction.
  #
  def next(1, 2), do: 1
  def next(_, 3), do: 1
  def next(_, _), do: 0
end

defmodule Conway.Cell.TestSuite do
  import TestHelper
  alias Conway.Cell

  def run_all do
    test_next_follows_B3S23_rules_given_a_dead_cell
    test_next_follows_B3S23_rules_given_an_alive_cell
    IO.write(".")
  end

  def test_next_follows_B3S23_rules_given_a_dead_cell do
    results = U.range(0, 9) |> Enum.map fn (neighbor_count) ->
      Cell.next(0, neighbor_count)
    end
    
    assert results == [0, 0, 0, 1, 0, 0, 0, 0, 0]
  end

  def test_next_follows_B3S23_rules_given_an_alive_cell do
    results = U.range(0, 9) |> Enum.map fn (neighbor_count) ->
      Cell.next(1, neighbor_count)
    end
    
    assert results == [0, 0, 1, 1, 0, 0, 0, 0, 0]
  end
end

defmodule Conway.Grid do
  alias Conway.Cell

  def generate(width, height) do
    Enum.map(U.range(0, height), fn (_) ->
      Enum.map(U.range(0, width), fn (_) ->
        Cell.generate
      end)
    end)
  end

  def displayable(grid) do
    lines = Enum.map(grid, fn (row) ->
      Enum.map(row, &Cell.displayable/1) |> Enum.join("")
    end)

    Enum.join(lines, "\n")
  end

  def extract_neighborhood(grid, x, y) do
    Enum.map([-1, 0, +1], fn (displace_y) ->
      Enum.map([-1, 0, +1], fn (displace_x) ->
        row  = U.nth(grid, y + displace_y)
        cell = U.nth(row,  x + displace_x)

        # Makes count_neighbors a lot simpler
        if 0 == displace_x and 0 == displace_y do
          0
        else
          Cell.maybe(cell)
        end
      end)
    end)
  end

  def count_neighbors(grid, x, y) do
    neighborhood = extract_neighborhood(grid, x, y)

    List.flatten(neighborhood) |> U.sum
  end

  def next(grid) do
    U.map_with_index(grid, fn (row, y) ->
      U.map_with_index(row, fn (cell, x) ->
        neighbor_count = count_neighbors(grid, x, y)
        Cell.next(cell, neighbor_count)
      end)
    end)
  end

  def step(_, 0, _) do end
  def step(grid, generation, callback) do
    new_grid = next(grid)
    callback.(new_grid)
    step(new_grid, generation - 1, callback)
  end
end

defmodule Conway.Grid.TestSuite do
  import TestHelper
  alias Conway.Grid

  def run_all do
    test_extract_neighborhood
    test_count_neighbors_given_empty
    test_count_neighbors_given_full
    test_next
    test_displayable
    test_generate
    IO.write(".")
  end

  # extracts the neighborhood around a set of coordinates, treating edges and the center like dead cells
  def test_extract_neighborhood do
    grid = [[1, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 0]];

    assert Grid.extract_neighborhood(grid, 0, 0) == [[0, 0, 0],
                                                     [0, 0, 0],
                                                     [0, 0, 0]]
    assert Grid.extract_neighborhood(grid, 1, 1) == [[1, 0, 0],
                                                     [0, 0, 0],
                                                     [0, 0, 1]]
    assert Grid.extract_neighborhood(grid, 0, 3) == [[0, 0, 0],
                                                     [0, 0, 0],
                                                     [0, 0, 0]]
    assert Grid.extract_neighborhood(grid, 3, 3) == [[1, 0, 0],
                                                     [0, 0, 0],
                                                     [0, 0, 0]]
  end

  def test_count_neighbors_given_empty do
    grid = [[0, 0, 0],
            [0, 0, 0],
            [0, 0, 0]]

    assert Grid.count_neighbors(grid, 1, 1) == 0
  end

  def test_count_neighbors_given_full do
    grid = [[1, 1, 1],
            [1, 1, 1],
            [1, 1, 1]]

    assert Grid.count_neighbors(grid, 1, 1) == 8
  end

  def test_next do
    grid = [[1, 0, 0, 0],
            [0, 0, 0, 0],
            [1, 0, 1, 0],
            [0, 0, 0, 0]]

    next = [[0, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0]]

    assert Grid.next(grid) == next
  end

  def test_displayable do
    grid = [[1, 0, 0, 0],
            [0, 0, 0, 0],
            [1, 0, 1, 0],
            [0, 0, 0, 0]]

    assert Grid.displayable(grid) == "•   \n    \n• • \n    "
  end

  # returns a randomly generated grid of the requested size
  def test_generate do
    grid = Grid.generate(8, 11)

    assert length(grid) == 11
    assert Enum.map(grid, &length/1) == [8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8]
  end
end

defmodule Conway.TestSuite do
  def run_all do
    Conway.Cell.TestSuite.run_all
    Conway.Grid.TestSuite.run_all
    IO.write("\n")
  end
end

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
