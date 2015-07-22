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
