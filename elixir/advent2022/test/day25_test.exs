defmodule Advent2022.Day25.Test do
  use ExUnit.Case
  import Advent2022.Day25

  test "to_snafu" do
    assert to_snafu(4890) == "2=-1=0"
  end
end
