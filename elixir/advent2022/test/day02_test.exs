defmodule Advent2022.Day02.Test do
  use ExUnit.Case
  alias Advent2022.Input
  import Advent2022.Day02

  test "part 1 decryption" do
    assert translate_part1({?A, ?Y}) == {1, 2}
    assert translate_part1({?B, ?X}) == {2, 1}
    assert translate_part1({?C, ?Z}) == {3, 3}
  end

  test "part 2 decryption" do
    assert translate_part2({?A, ?Y}) == {1, 1}
    assert translate_part2({?B, ?X}) == {2, 1}
    assert translate_part2({?C, ?Z}) == {3, 1}
  end

  @sample_input "A Y
B X
C Z"

  test "play game part 1" do
    rounds = @sample_input
    |> Input.lines()
    |> Enum.map(&read_round/1)
    assert play_game(rounds, &translate_part1/1) == 15
  end

  test "play game part 2" do
    rounds = @sample_input
    |> Input.lines()
    |> Enum.map(&read_round/1)
    assert play_game(rounds, &translate_part2/1) == 12
  end
end
