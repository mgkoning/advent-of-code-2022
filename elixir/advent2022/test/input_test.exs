defmodule Advent2022.Input.Test do
  alias Advent2022.Input
  use ExUnit.Case

  test "break input into lines" do
    assert Input.lines("") == [""]
    assert Input.lines("a\nb") == ["a", "b"]
  end

  test "break input into tuple" do
    assert Input.tuple("1,2", ~r/,/) == {"1", "2"}
  end

  test "break input into tuple and parse" do
    assert Input.tuple("1,2", ~r/,/, &String.to_integer/1) == {1, 2}
  end
end
