defmodule Advent2022.Day23 do
  alias Advent2022.Input
  defmodule State do
    defstruct elves: MapSet.new, order: [{0, -1}, {0, 1}, {-1, 0}, {1, 0}]
  end

  def solve(input) do
    elves = read_elves(input)
    IO.puts("Part 1:")
    IO.puts(part1(elves))
    IO.puts("Part 2:")
    IO.puts(part2(elves))
  end

  def part1(elves) do
    [result] = Stream.iterate(%State{elves: elves}, &step/1)
    |> Stream.drop(10)
    |> Enum.take(1)
    [{some_x, some_y}] = Enum.take(result.elves, 1)
    {min_x, min_y, max_x, max_y} = Enum.reduce(
      result.elves,
      {some_x, some_y, some_x, some_y},
      fn {x, y}, {min_x, min_y, max_x, max_y} ->
        {min(x, min_x), min(y, min_y), max(x, max_x), max(y, max_y)} end)
    (max_x - min_x + 1) * (max_y - min_y + 1) - Enum.count(result.elves)
  end

  def part2(elves) do
    [{_, round}] = Stream.iterate(%State{elves: elves}, &step/1)
    |> Stream.chunk_every(2,1)
    |> Stream.with_index(1)
    |> Stream.drop_while(fn {[prv, nxt], _} -> prv.elves != nxt.elves end)
    |> Enum.take(1)
    round
  end

  def step(%State{elves: elves, order: [o | os]} = state) do
    intended_moves = Enum.map(elves, &consider_move(&1, state))
    conflicts = intended_moves
    |> Enum.reduce(%{}, fn {_, to}, acc -> Map.update(acc, to, 1, & &1 + 1) end)
    |> Enum.filter(fn {_, count} -> 1 < count end)
    |> Map.new
    new_elves = intended_moves
    |> Enum.map(fn {from, to} -> if Map.has_key?(conflicts, to), do: from, else: to end)
    |> MapSet.new
    %{state | elves: new_elves, order: os ++ [o]}
  end

  @directions for x <- -1..1, y <- -1..1, x != 0 || y != 0, do: {x, y}

  defp consider_move(elf, %State{elves: elves, order: order}) do
    neighbors = Enum.map(@directions, &add(elf, &1))
    if Enum.count(neighbors, &MapSet.member?(elves, &1)) < 1 do
      {elf, elf}
    else
      direction = order
      |> Enum.find(
        {0, 0}, # don't move if blocked in all directions; not explicit in puzzle description
        fn o ->
          side_neighbors = direction_neighbors(o)
          |> Enum.map(&add(elf, &1))
          |> Enum.count(&MapSet.member?(elves, &1))
          side_neighbors < 1 end)
      {elf, add(elf, direction)}
    end
  end

  defp add({x0, y0}, {x1, y1}), do: {x0+x1, y0+y1}

  defp direction_neighbors({0, dy}), do: for dx <- -1..1, do: {dx, dy}
  defp direction_neighbors({dx, 0}), do: for dy <- -1..1, do: {dx, dy}

  def read_elves(input) do
    Input.read_grid(input, &Function.identity/1)
    |> Enum.filter(fn {_, c} -> c == ?# end)
    |> Enum.map(fn {p, _} -> p end)
    |> MapSet.new
  end
end
