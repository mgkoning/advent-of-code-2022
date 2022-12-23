defmodule Advent2022.Day23.Test do
  use ExUnit.Case
  import Advent2022.Day23

  @small_sample ".....
..##.
..#..
.....
..##.
....."

  @sample_input "....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#.."

  test "part 1 small sample" do
    elves = read_elves(@small_sample)
    assert part1(elves) == 25
  end

  test "part 1 sample" do
    elves = read_elves(@sample_input)
    assert part1(elves) == 110
  end

  test "part 2 small sample" do
    elves = read_elves(@small_sample)
    assert part2(elves) == 4
  end

  test "part 2 sample" do
    elves = read_elves(@sample_input)
    assert part2(elves) == 20
  end

  def show_elves(elves) do
    {min_x, max_x} = Enum.map(elves, &elem(&1, 0)) |> Enum.min_max()
    {min_y, max_y} = Enum.map(elves, &elem(&1, 1)) |> Enum.min_max()
    for y <- min_y-1..max_y+1 do
      (for x <- min_x-1..max_x+1, do: if MapSet.member?(elves, {x, y}), do: ?#, else: ?.)
      |> List.to_string()
    end
    |> Enum.join("\n")
    |> IO.puts
  end
end
