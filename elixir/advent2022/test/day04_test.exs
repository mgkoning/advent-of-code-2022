defmodule Advent2022.Day04.Test do
  import Advent2022.Day04
  use ExUnit.Case

  test "fully contains" do
    assert one_fully_contains_other({{2,4}, {6,8}}) == false
    assert one_fully_contains_other({{2,8}, {3,7}}) == true
    assert one_fully_contains_other({{3,7}, {2,8}}) == true
    assert one_fully_contains_other({{2,6}, {4,8}}) == false
  end

  test "has overlap" do
    assert has_overlap({{2,4}, {6,8}}) == false
    assert has_overlap({{2,8}, {3,7}}) == true
    assert has_overlap({{2,6}, {4,8}}) == true
    assert has_overlap({{6,6}, {4,6}}) == true
    assert has_overlap({{5,7}, {7,9}}) == true
    assert has_overlap({{7,9}, {5,7}}) == true
  end
end
