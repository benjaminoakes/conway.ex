defmodule Conway.TestSuite do
  def run_all do
    Conway.Cell.TestSuite.run_all
    Conway.Grid.TestSuite.run_all
    IO.write("\n")
  end
end
