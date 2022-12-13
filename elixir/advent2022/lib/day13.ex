defmodule Advent2022.Day13 do
  alias Advent2022.Input
  def solve(input) do
    signal = read_signal(input)
    IO.puts("Part 1:")
    IO.puts(part1(signal))
    IO.puts("Part 2:")
    IO.puts(part2(signal))
  end

  def part1(signal) do
    signal
    |> Enum.map(fn [left, right] -> compare(left, right) end)
    |> Enum.map(& &1 < 0)
    |> Enum.with_index(1)
    |> Enum.filter(&elem(&1, 0))
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  @divider_2 [[2]]
  @divider_6 [[6]]
  def part2(signal) do
    [@divider_2, @divider_6 | Enum.flat_map(signal, &Function.identity/1)]
    |> Enum.sort(&compare(&1, &2) < 0)
    |> Enum.with_index(1)
    |> Enum.filter(&(elem(&1, 0) == @divider_2 || elem(&1, 0) == @divider_6))
    |> Enum.map(&elem(&1, 1))
    |> Enum.product()
  end

  def compare([l | ls], [r | rs]) do
    compared = compare(l, r)
    if compared == 0, do: compare(ls, rs), else: compared
  end
  def compare([], []), do: 0
  def compare([], r) when is_list(r), do: -1
  def compare(l, []) when is_list(l), do: 1
  def compare(l, r) when not is_list(l) and not is_list(r), do: l - r
  def compare(l, r) when not is_list(l), do: compare([l], r)
  def compare(l, r) when not is_list(r), do: compare(l, [r])

  def read_signal(input) do
    input
    |> Input.sections()
    |> Enum.map(&read_pair/1)
  end

  def read_pair(input) do
    input
    |> Input.lines()
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&read_value/1)
    |> Enum.map(&hd/1)
  end

  def read_value([x | rest]) do
    case x do
      ?[ -> read_list(rest, [])
      _ -> read_integer(rest, x - ?0)
    end
  end

  def read_list([x | rest] = list, so_far) do
    case x do
      ?] -> [Enum.reverse(so_far), rest]
      ?, -> read_list(rest, so_far)
      _ ->
        [val, rem] = read_value(list)
        read_list(rem, [val | so_far])
    end
  end

  def read_integer([x | rest] = list, val) do
    case x do
      ?, -> [val, list]
      ?] -> [val, list]
      _ -> read_integer(rest, val * 10 + x - ?0)
    end
  end
end
