defmodule Advent2022.Day05.Test do
  import Advent2022.Day05
  use ExUnit.Case

  @sample_stacks "    [D]    \n" <> "[N] [C]    \n" <> "[Z] [M] [P]\n" <> " 1   2   3 "

  test "read_stacks" do
    assert read_stacks(@sample_stacks) == %{1 => 'NZ', 2 => 'DCM', 3 => 'P'}
  end
end
