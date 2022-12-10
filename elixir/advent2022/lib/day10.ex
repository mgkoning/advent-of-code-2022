defmodule Advent2022.Day10 do
  alias Advent2022.Input
  def solve(input) do
    values = read_instructions(input)
    |> run_instructions()
    IO.puts("Part 1:")
    IO.puts(part1(values))
    IO.puts("Part 2:")
    IO.puts("\n#{part2(values)}\n")
  end

  def run_instructions(instructions) do
    [1 | instructions
          |> Enum.flat_map(&interpret/1)
          |> Enum.scan(1, &(&1 + &2))]
  end

  def part1(values) do
    values
    |> Input.enumerated(1)
    |> Stream.drop(19)
    |> Stream.take_every(40)
    |> Stream.map(fn {i, value} -> i * value end)
    |> Enum.sum()
  end

  def part2(values) do
    values
    |> Enum.zip_with(0..(6*40-1), fn v, x -> to_pixel(rem(x, 40), v) end)
    |> Enum.chunk_every(40)
    |> Enum.map(&List.to_string/1)
    |> Enum.join("\n")
  end

  def to_pixel(x, value) do
    if value - 1 <= x && x <= value + 1, do: ?@, else: ?\s
  end

  def interpret({:noop}), do: [0]
  def interpret({:addx, change}), do: [0, change]

  def read_instructions(input) do
    input
    |> Input.lines()
    |> Enum.map(&Input.words/1)
    |> Enum.map(&to_instruction/1)
  end

  defp to_instruction(["noop"]), do: {:noop}
  defp to_instruction(["addx", value]), do: {:addx, String.to_integer(value)}
end
