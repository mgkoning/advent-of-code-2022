defmodule Advent2022.Test do
  use ExUnit.Case

  test "it parses numbers" do
    assert Advent2022.determine_day(["1"]) == 1
  end
end
