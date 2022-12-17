defmodule Advent2022.Day12 do
  alias Advent2022.Input
  alias Advent2022.Common
  def solve(input) do
    {map, [start], [destination]} = read_map(input)
    IO.puts("Part 1:")
    IO.puts(find_shortest(map, start, destination))
    IO.puts("Part 2:")
    all_lowest_elevations = Map.filter(map, fn {_, v} -> v == ?a end) |> Map.keys()
    shortest = all_lowest_elevations
    |> Enum.map(&find_shortest(map, &1, destination))
    |> Enum.sort()
    |> hd()
    IO.puts(shortest)
  end

  defp find_shortest(map, start, destination) do
    to_visit = [{start, 0}]
    visited = MapSet.new([start])
    find_shortest_inner(map, destination, to_visit, visited)
  end

  @infinity 100000000

  defp find_shortest_inner(_, _, [], _), do: 100000000
  defp find_shortest_inner(map, destination, to_visit, visited) do
    [{next, length} | rest] = to_visit
    neighbors = find_neighbors(map, next) |> Enum.filter(&(!MapSet.member?(visited, &1)))
    if Enum.any?(neighbors, &(&1 == destination)) do
      length + 1
    else
      visited_new = Enum.reduce(neighbors, visited, fn n, acc -> MapSet.put(acc, n) end)
      to_visit_new = Enum.reduce(neighbors, rest, fn n, acc -> Common.insert_sorted(acc, {n, length + 1}) end)
      find_shortest_inner(map, destination, to_visit_new, visited_new)
    end
  end

  defp find_neighbors(map, {x, y} = pos) do
    elevation = Map.fetch!(map, pos)
    adjacent = for {dx, dy} <- [{0, 1}, {0, -1}, {1, 0}, {-1, 0}], do: {x + dx, y + dy}
    Enum.filter(adjacent, fn pos -> Map.get(map, pos, @infinity) < elevation + 2 end)
  end

  defp read_map(input) do
    entries = for {line, y} <- input |> Input.lines() |> Enum.with_index(),
                  {char, x} <- line |> String.to_charlist() |> Enum.with_index() do
      {{x, y}, char}
    end
    entries
    |> Enum.reduce({%{}, [], []}, fn {pos, c}, {map, start, destination} ->
      elevation = case c do
        ?E -> ?z
        ?S -> ?a
        c -> c
      end
      {Map.put(map, pos, elevation), (if c == ?S, do: [pos], else: start), (if c == ?E, do: [pos], else: destination)}
    end)
  end
end
