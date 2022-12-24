defmodule Advent2022.Day24 do
  alias Advent2022.Coord
  alias Advent2022.Input

  def solve(input) do
    IO.puts("Part 1:")
    {blizzards, bottom_right} = read_map(input)
    IO.puts(part1(blizzards, bottom_right))
    IO.puts("Part 2:")
    IO.puts(part2(blizzards, bottom_right))
  end

  def part1(blizzards_start, {max_x, max_y} = bottom_right) do
    destination = {max_x-1, max_y}
    start_at = {1, 0}
    {time, _} = walk_expedition(%{ 0 => blizzards_start }, bottom_right, start_at, destination)
    time
  end

  def part2(blizzards_start, {max_x, max_y} = bottom_right) do
    start_at = {1, 0}
    destination = {max_x-1, max_y}
    {time, _} = Stream.cycle([start_at, destination])
    |> Enum.take(4)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(
      {0, %{ 0 => blizzards_start }},
      fn [from, to], {time, blizzards} -> walk_expedition(blizzards, bottom_right, from, to, time) end)
    time
  end

  def walk_expedition(blizzards, bottom_right, from, to, time \\ 0) do
    start_point = {from, time}
    do_walk_expedition([with_heur(start_point, to)], blizzards, bottom_right, from, to, MapSet.new([start_point]))
  end

  @possible_moves [{1,0}, {0,1}, {-1, 0}, {0, -1}, {0,0}]
  def do_walk_expedition(
    [{pos, time, _} | to_visit],
    blizzards_at_time,
    {max_x, max_y} = bottom_right,
    start,
    destination,
    visited) do

    updated_blizzards = Map.put_new_lazy(
      blizzards_at_time, time + 1,
      fn -> move_blizzards(Map.fetch!(blizzards_at_time, time), bottom_right) end)
    blizzards = Map.get(updated_blizzards, time + 1)
    options = Enum.map(@possible_moves, &{Coord.add(pos, &1), time+1})
    |> Enum.filter(&!MapSet.member?(visited, &1))
    |> Enum.filter(&!Map.has_key?(blizzards, elem(&1, 0)))
    if Enum.any?(options, fn {pos, _} -> pos == destination end) do
      {time + 1, updated_blizzards}
    else
      allowed = Enum.filter(options, fn {{x, y} = p, _} -> p == start || 0 < x && x < max_x && 0 < y && y < max_y end)
      new_visited = Enum.reduce(allowed, visited, fn el, acc -> MapSet.put(acc, el) end)
      new_to_visit = Enum.reduce(allowed, to_visit, fn el, acc -> insert_sorted(acc, with_heur(el, destination)) end)
      do_walk_expedition(new_to_visit, updated_blizzards, bottom_right, start, destination, new_visited)
    end
  end

  defp with_heur({pos, time}, destination), do: {pos, time, time + manh(pos, destination)}

  defp insert_sorted([], e), do: [e]
  defp insert_sorted([{_, _, heur_v} = v | vs], {_, _, heur_e} = e) do
    if heur_v < heur_e do
      [v | insert_sorted(vs, e)]
    else
      [e, v | vs]
    end
  end

  defp manh({x0, y0}, {x1, y1}), do: abs(x0 - x1) + abs(y0 - y1)

  defp move_blizzards(blizzards, {max_x, max_y}) do
    blizzards
    |> Enum.flat_map(fn {pos, directions} -> Enum.map(directions, &{pos, &1}) end)
    |> Enum.map(fn {pos, direction} ->
      {new_x, new_y} = Coord.add(pos, direction)
      {{wrap(new_x, max_x), wrap(new_y, max_y)}, direction} end)
    |> Enum.reduce(%{}, fn {pos, dir}, acc -> Map.update(acc, pos, [dir], &[dir | &1]) end)
  end
  defp wrap(val, max), do: if val < 1, do: max - 1, else: if max <= val, do: 1, else: val

  def read_map(input) do
    valley_map = Input.read_grid(input, &read_tile/1)
    blizzards = valley_map
    |> Enum.filter(fn {_k, v} -> v != :empty && v != :wall end)
    |> Map.new
    bottom_right = valley_map |> Map.keys() |> Enum.max()
    {blizzards, bottom_right}
  end

  defp read_tile(char) do
    case char do
      ?. -> :empty
      ?# -> :wall
      ?> -> [{1, 0}]
      ?< -> [{-1, 0}]
      ?^ -> [{0, -1}]
      ?v -> [{0, 1}]
    end
  end
end
