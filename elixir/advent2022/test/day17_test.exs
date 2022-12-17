defmodule Advent2022.Day17.Test do
  use ExUnit.Case
  import Advent2022.Day17

  @sample_input ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"

  test "part 1" do
    gas_jets = read_gas_jets(@sample_input)
    assert part1(gas_jets) == 3068
  end
end
