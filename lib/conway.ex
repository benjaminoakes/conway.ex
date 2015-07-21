defmodule TestHelper do
  def assert(condition) do
    if !condition do
      raise "assert failed"
    end
  end
end

defmodule U do
  def range(start, start), do: []
  def range(start, stop) when start + 1 == stop, do: [start]
  def range(start, stop),  do: [start | range(start + 1, stop)]

  def nth(list, n) when n >= 0, do: Enum.at(list, n)
  def nth(_, n)    when n < 0,  do: nil
end

defmodule Conway.Cell do
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
    IO.puts(".")
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

  def extract_neighborhood(grid, x, y) do
    Enum.map([-1, 0, +1], fn (displace_y) ->
      Enum.map([-1, 0, +1], fn (displace_x) ->
        row = U.nth(grid, y + displace_y)

        if row do
          cell = U.nth(row, x + displace_x)

          if 0 == displace_x and 0 == displace_y do
            0
          else
            if cell do
              cell
            else
              0
            end
          end
        else
          0
        end
      end)
    end)
  end

  defp sum(accumulator, e) do
    accumulator + e
  end

  def count_neighbors(grid, x, y) do
    neighborhood = extract_neighborhood(grid, x, y)

    List.flatten(neighborhood)
      |> Enum.reduce(0, &sum/2)
  end

  def next(grid) do
    Enum.with_index(grid)
      |> Enum.map(fn ({ row, y }) ->
        Enum.with_index(row)
        |> Enum.map(fn ({ cell, x }) ->
          neighbor_count = count_neighbors(grid, x, y)
          Cell.next(cell, neighbor_count)
      end)
    end)
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
    IO.puts(".")
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
end

Conway.Cell.TestSuite.run_all
Conway.Grid.TestSuite.run_all
