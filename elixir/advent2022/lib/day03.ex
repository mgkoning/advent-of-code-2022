defmodule Advent2022.Day03 do
  alias Advent2022.Input

  def solve(input) do
    lines = input |> Input.lines()
    IO.puts("Part 1:")
    part1 = lines
    |> Enum.map(&rucksack_halves/1)
    |> common_to_priority()
    IO.puts(part1)
    IO.puts("Part 2:")
    part2 = Enum.chunk_every(lines, 3)
    |> common_to_priority()
    IO.puts(part2)
  end

  defp common_to_priority(groups) do
    groups
    |> Enum.map(&find_common/1)
    |> Enum.map(&to_priority/1)
    |> Enum.sum()
  end

  @spec find_common([binary()]) :: char()
  def find_common(group) do
    group
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> MapSet.to_list()
    |> List.first()
  end

  @spec to_priority(char()) :: char()
  def to_priority(char) do
    case char do
      char when ?a <= char and char <= ?z -> char - ?a + 1
      char when ?A <= char and char <= ?Z -> 26 + char - ?A + 1
    end
  end

  @spec rucksack_halves(binary) :: [binary]
  def rucksack_halves(line) do
    half = line
    |> String.length()
    |> div(2)
    line
    |> String.split_at(half)
    |> Tuple.to_list()
  end
end
