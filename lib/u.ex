defmodule U do
  def range(start, start), do: []
  def range(start, stop) when start + 1 == stop, do: [start]
  def range(start, stop),  do: [start | range(start + 1, stop)]

  def nth(nil, _),              do: nil
  def nth(list, n) when n >= 0, do: Enum.at(list, n)
  def nth(_, n)    when n < 0,  do: nil

  def map_with_index(list, callback) do
    Enum.with_index(list)
      |> Enum.map(fn ({ element, index }) ->
        callback.(element, index)
      end)
  end

  def sum(list) do
    Enum.reduce(list, 0, &+/2)
  end
end
