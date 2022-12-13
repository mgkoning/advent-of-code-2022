defmodule Advent2022.Day13.Test do
  use ExUnit.Case
  import Advent2022.Day13

  @sample_input "[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]"

  test "sample input part 1" do
    signal = read_signal(@sample_input)
    assert part1(signal) == 13
  end

  test "sample input part 2" do
    signal = read_signal(@sample_input)
    assert part2(signal) == 140
  end
end
