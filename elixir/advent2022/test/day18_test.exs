defmodule Advent2022.Day18.Test do
  use ExUnit.Case
  import Advent2022.Day18

  @sample_input "2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5"

  test "part 2" do
    cubes = read_cubes(@sample_input)
    {all_free_sides, count} = part1(cubes)
    assert count == 64
    assert part2(cubes, all_free_sides) == 58
  end
end
