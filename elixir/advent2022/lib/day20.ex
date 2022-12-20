defmodule Advent2022.Day20 do
  alias Advent2022.Zipper
  alias Advent2022.Input

  def solve(input) do
    coordinates = read_coordinates(input)
    IO.puts("Part 1:")
    IO.puts(part1(coordinates))
    IO.puts("Part 2:")
    IO.puts(part2(coordinates))
  end

  def part1(coordinates) do
    mix(coordinates)
    |> Stream.cycle()
    |> Stream.take_every(1000)
    |> Stream.drop(1)
    |> Enum.take(3)
    |> Enum.sum()
  end

  def part2(coordinates) do
    mix(coordinates |> Enum.map(& &1 * 811589153), 10)
    |> Stream.cycle()
    |> Stream.take_every(1000)
    |> Stream.drop(1)
    |> Enum.take(3)
    |> Enum.sum()
  end

  def mix(coordinates, rounds \\ 1) do
    size = Enum.count(coordinates)
    coordinates_reduced = coordinates
    |> Enum.map(fn c -> {wrap_around(c, size-1), c} end)
    coordinates_with_order = Enum.with_index(coordinates_reduced, 0)
    mixed = for _round <- 1..rounds, reduce: %Zipper{next: coordinates_with_order} do
      round_acc ->
        for index <- 0..size-1, reduce: round_acc do
          acc ->
            rotated = Zipper.find(acc, fn {_x, i} -> i == index end, size)
            {{{to_move, _}, _} = v, remaining_zipper} = Zipper.pop(rotated)
            moved = remaining_zipper
            |> Zipper.move(to_move)
            |> Zipper.push(v)
            moved
        end
    end
    Zipper.find(mixed, fn {{_, x}, _} -> x == 0 end, size)
    |> Zipper.to_list()
    |> Enum.map(fn {{_, x}, _} -> x end)
  end

  defp wrap_around(v, wrap_at) do
    reduced = rem(v, wrap_at)
    if reduced < 0, do: reduced + wrap_at, else: reduced
  end

  def read_coordinates(input) do
    Input.convert_lines(input, &String.to_integer/1)
  end
end
