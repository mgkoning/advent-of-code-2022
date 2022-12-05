defmodule Advent2022.Day05 do
  alias Advent2022.Input
  def solve(input) do
    [stacks_input, instructions_input] = input
    |> String.split(~r/\n\n/)
    stacks = read_stacks(stacks_input)
    instructions = read_instructions(instructions_input)
    IO.puts("Part 1:")
    part1 = run_instructions(stacks, instructions, &Enum.reverse/1)
    IO.puts(part1)
    IO.puts("Part 2:")
    part2 = run_instructions(stacks, instructions, fn x -> x end)
    IO.puts(part2)
  end

  defp run_instructions(stacks, instructions, order_fn) do
    instructions
    |> Enum.scan(stacks, fn i, stacks -> run_instruction(i, stacks, order_fn) end)
    |> List.last()
    |> all_heads()
  end

  defp all_heads(stacks) do
    Enum.reduce(9..1//-1, [], fn el, acc -> [Map.fetch!(stacks, el) |> List.first() | acc] end)
  end

  defp run_instruction({count, from, to}, stacks, order_fn) do
    {moved, remaining} = Map.fetch!(stacks, from) |> Enum.split(count)
    stacks
    |> Map.put(from, remaining)
    |> Map.update!(to, &Enum.concat(order_fn.(moved), &1))
  end

  def read_stacks(input) do
    extract_values = fn line ->
      String.to_charlist(line)
      |> Enum.drop(1)
      |> Enum.take_every(4)
    end

    [indices | crates] = input
    |> Input.lines()
    |> Enum.map(&extract_values.(&1))
    |> Enum.reverse()

    stacks = crates
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.filter(&1, fn c -> c != ?\s end))
    |> Enum.map(&Enum.reverse/1)

    indices
    |> Enum.map(&(&1 - ?1 + 1))
    |> Enum.zip_reduce(stacks, %{}, fn i, s, acc -> Map.put(acc, i, s) end)
  end

  defp read_instructions(input) do
    input
    |> Input.lines()
    |> Enum.map(&String.split/1)
    |> Enum.map(&line_parts_to_instruction/1)
  end

  defp line_parts_to_instruction([_, count, _, from, _, to]) do
    [count, from, to]
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end
