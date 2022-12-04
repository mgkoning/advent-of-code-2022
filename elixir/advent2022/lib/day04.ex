defmodule Advent2022.Day04 do
  alias Advent2022.Input
  def solve(input) do
    pairs = input
    |> Input.lines()
    |> Enum.map(&read_pair/1)
    IO.puts("Part 1:")
    pairs
    |> Enum.filter(&one_fully_contains_other/1)
    |> Enum.count()
    |> IO.puts()
    IO.puts("Part 2:")
    pairs
    |> Enum.filter(&has_overlap/1)
    |> Enum.count()
    |> IO.puts()
  end

  def has_overlap({{from1, to1}, {from2, to2}}), do: from1 <= to2 && from2 <= to1

  def one_fully_contains_other({one, other}) do
    contains_fully(one, other) || contains_fully(other, one)
  end

  defp contains_fully(_larger = {from1, to1}, _smaller = {from2, to2}) do
    from1 <= from2 && to2 <= to1
  end

  defp read_pair(line), do: Input.tuple(line, ~r/,/, &read_range/1)

  defp read_range(value), do: Input.tuple(value, ~r/-/, &String.to_integer/1)

end
