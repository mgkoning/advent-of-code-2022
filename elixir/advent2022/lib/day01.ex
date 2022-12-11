defmodule Advent2022.Day01 do
  alias Advent2022.Input
  def solve(input) do
    burdens = input |> burdens_by_heaviest()
    IO.puts("Part 1:")
    IO.puts(sum_topN(burdens, 1))
    IO.puts("Part 2:")
    IO.puts(sum_topN(burdens, 3))
  end

  def sum_topN(burdens, n) do
    burdens |> Enum.take(n) |> Enum.sum()
  end

  def burdens_by_heaviest(input) do
    input
    |> read_elves()
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort()
    |> Enum.reverse()
  end

  defp read_elves(input) do
    Input.sections(input)
    |> Enum.map(&read_elf/1)
  end

  defp read_elf(value) do
    value
    |> Input.lines()
    |> Enum.map(&String.to_integer/1)
  end
end
