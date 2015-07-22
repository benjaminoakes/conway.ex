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
