defmodule Advent2022.Day01.Test do
  alias Advent2022.Day01
  use ExUnit.Case

  @sample_input "1000
2000
3000

4000

5000
6000

7000
8000
9000

10000"

  test "sample input" do
    assert Day01.solve(@sample_input) == :ok
  end
end
