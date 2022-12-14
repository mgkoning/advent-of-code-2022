defmodule Advent2022.Day08 do
  alias Advent2022.Common
  alias Advent2022.Input

  def solve(input) do
    grid = read_grid(input)
    IO.puts("Part 1:")
    visibles = for pos <- Map.keys(grid) do
      run_neighbor_fn(grid, pos, &tree_visible_from/2) |> Enum.any?()
    end
    IO.puts(Enum.count(visibles, &(&1)))

    IO.puts("Part 2:")
    scores = for pos <- Map.keys(grid) do
      run_neighbor_fn(grid, pos, &viewing_distance/2) |> Enum.product()
    end
    IO.puts(Enum.max(scores))
  end

  defp tree_visible_from(side_enum, height), do: Enum.all?(side_enum, &(&1 < height))

  defp viewing_distance(side_enum, height) do
    Common.take_until_including(side_enum, &(height <= &1)) |> Enum.count()
  end

  defp run_neighbor_fn(grid, pos, fun) do
    here = Map.get(grid, pos)
    for {dx, dy} <- [{-1,0}, {1,0}, {0,-1}, {0,1}] do
      Stream.iterate(pos, fn {x, y} -> {x+dx, y+dy} end)
      |> Stream.drop(1)
      |> Stream.map(&Map.get(grid, &1))
      |> Stream.take_while(&(&1 != nil))
      |> Enum.into([])
      |> fun.(here)
    end
  end

  def read_grid(input), do: Input.read_grid(input, fn c -> c - ?0 end)
end
