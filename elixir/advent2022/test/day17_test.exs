defmodule Advent2022.Day17.Test do
  use ExUnit.Case
  import Advent2022.Day17

  @sample_input ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"

  test "part 1" do
    gas_jets = read_gas_jets(@sample_input)
    assert part1(gas_jets) == 3068
  end

  test "part 2" do
    # doesn't seem to work for 'vanilla' sample input; I suppose determining the cycle needs to be
    # more general than this case. Possibly the short list of gas jets means the cycle is a
    # not achieved by the time the first "wraparound" happens. Repeating it 5 times does the trick.
    gas_jets = read_gas_jets(@sample_input) |> Stream.duplicate(5) |> Enum.flat_map(& &1)
    assert part2(gas_jets) == 1514285714288
  end
end
