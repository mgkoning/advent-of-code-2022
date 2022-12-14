defmodule Advent2022.Day14.Test do
  use ExUnit.Case
  import Advent2022.Day14

  @sample_input "498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9"

  test "part 1, sample input" do
    paths = read_rock_paths(@sample_input)
    assert pour(paths) == 24
  end

  test "part 2, sample input" do
    paths = read_rock_paths(@sample_input)
    assert pour(paths, &part2_floor/2) == 93
  end
end
