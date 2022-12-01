defmodule Advent2022.Day01 do
  def solve(input) do
    burdens = input
    |> read_elves()
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort()
    |> Enum.reverse()
    IO.puts("Part 1:")
    IO.puts(Enum.fetch!(burdens, 0))
    IO.puts("Part 2:")
    IO.puts(burdens |> Enum.take(3) |> Enum.sum())
  end

  defp read_elves(input) do
    String.split(input, ~r/\n\n/)
    |> Enum.map(&read_elf/1)
  end

  defp read_elf(value) do
    String.split(value, ~r/\n/)
    |> Enum.map(&String.to_integer/1)
  end
end
