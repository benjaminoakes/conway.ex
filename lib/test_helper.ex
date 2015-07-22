defmodule TestHelper do
  def assert(condition) do
    if !condition do
      raise "assert failed"
    end
  end
end
