defmodule Advent2022.Day14 do
  alias Advent2022.Input

  def solve(input) do
    paths = read_rock_paths(input)
    IO.puts("Part 1:")
    IO.puts(pour(paths))
    IO.puts("Part 2:")
    IO.puts(pour(paths, &part2_floor/2))
  end

  defp no_floor(_, _), do: false
  def part2_floor(bottom, {_, y}), do: bottom + 2 <= y

  @pour_from {500, 0}
  def pour(paths, is_floor? \\ &no_floor/2) do
    bottom = Map.keys(paths) |> Enum.map(&elem(&1, 1)) |> Enum.max()
    [{last_state, _}] = Stream.iterate({paths, nil}, fn {map, _} -> drop_sand(map, bottom, is_floor?, @pour_from) end)
    |> Stream.drop(1)
    |> Stream.drop_while(fn {_, rest_at} -> rest_at != nil && rest_at != @pour_from end)
    |> Enum.take(1)
    # show_map(last_state) # Just for fun
    last_state
    |> Map.filter(&elem(&1, 1) == :sand)
    |> map_size()
  end

  def drop_sand(map, bottom, _, {_, y}) when bottom + 3 < y, do: {map, nil}
  def drop_sand(map, bottom, is_floor?, from) do
    next = determine_next(map, from, &is_floor?.(bottom, &1))
    if next == from do
      {Map.put(map, next, :sand), next}
    else
      drop_sand(map, bottom, is_floor?, next)
    end
  end
  def determine_next(map, {x, y} = current, is_floor?) do
    [{0, 1}, {-1, 1}, {1, 1}]
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.drop_while(fn pos -> Map.has_key?(map, pos) || is_floor?.(pos) end)
    |> List.first(current)
  end

  def read_rock_paths(input) do
    input
    |> Input.lines()
    |> Enum.flat_map(&read_rock_path/1)
    |> Enum.into(Map.new())
  end

  def read_rock_path(line) do
    line
    |> String.split(" -> ")
    |> Enum.map(&Input.coord/1)
    |> Enum.chunk_every(2, 1)
    |> Enum.flat_map(&draw_line/1)
  end

  def draw_line([_]), do: []
  def draw_line([{x_0, y_0}, {x_1, y_1}]) do
    for x <- step_through(x_0, x_1), y <- step_through(y_0, y_1) do
      {{x, y}, :rock}
    end
  end
  def step_through(from, to), do: from..to//(if from <= to, do: 1, else: -1)

  # Just for fun!
  def show_map(map) do
    {xs, ys} = Map.keys(map) |> Enum.unzip()
    for y <- Enum.min(ys)..Enum.max(ys) do
      for x <- Enum.min(xs)..Enum.max(xs) do
        case Map.get(map, {x, y}) do
          :rock -> ?#
          :sand -> ?o
          _ -> ?\s
        end
      end
      |> List.to_string()
    end
    |> Enum.join("\n")
    |> IO.puts()
  end
end
