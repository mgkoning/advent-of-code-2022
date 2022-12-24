defmodule Advent2022.Day24.Test do
  use ExUnit.Case
  import Advent2022.Day24

  @sample_input "#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#"

  test "part 1" do
    {blizzards, bottom_right} = read_map(@sample_input)
    assert part1(blizzards, bottom_right) == 18
  end

  test "part 2" do
    {blizzards, bottom_right} = read_map(@sample_input)
    assert part2(blizzards, bottom_right) == 54
  end
end
