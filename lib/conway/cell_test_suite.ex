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
