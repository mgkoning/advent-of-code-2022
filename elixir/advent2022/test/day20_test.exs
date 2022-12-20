defmodule Advent2022.Day20.Test do
  use ExUnit.Case
  import Advent2022.Day20

  @sample_input "1
2
-3
3
-2
0
4"

  test "mix" do
    assert mix(read_coordinates(@sample_input)) == [0, 3, -2, 1, 2, -3, 4]
  end

  test "part 1" do
    assert part1(read_coordinates(@sample_input)) == 3
  end

end
