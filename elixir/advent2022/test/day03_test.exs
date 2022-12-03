defmodule Advent2022.Day03.Test do
  use ExUnit.Case
  import Advent2022.Day03

  test "rucksack halves determined correctly" do
    assert rucksack_halves("vJrwpWtwJgWrhcsFMMfFFhFp") == ["vJrwpWtwJgWr", "hcsFMMfFFhFp"]
  end

  test "priorities are correct" do
    assert to_priority(?a) == 1
    assert to_priority(?z) == 26
    assert to_priority(?A) == 27
    assert to_priority(?Z) == 52
    assert to_priority(?r) == 18
    assert to_priority(?P) == 42
  end

  test "find common" do
    assert find_common(["vJrwpWtwJgWr", "hcsFMMfFFhFp"]) == ?p
    assert find_common([
      "vJrwpWtwJgWrhcsFMMfFFhFp", "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
       "PmmdzqPrVvPwwTWBwg"]) == ?r
  end
end
