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
