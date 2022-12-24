defmodule Advent2022.Day22 do
  alias Advent2022.Input

  defmodule MonkeyMap do
    defstruct map: %{}, edges_by_row: %{}, edges_by_column: %{}
  end

  def solve(input) do
    {basic_map, instructions} = read_input(input)
    monkey_map = prepare_map(basic_map)
    IO.puts("Part 1:")
    IO.puts(part1(monkey_map, instructions))
  end

  def part1(monkey_map, instructions) do
    {start_pos, _} = Map.fetch!(monkey_map.edges_by_row, 1)
    {{x, y}, facing} = instructions
    |> Enum.reduce({start_pos, {1, 0}}, &step(monkey_map, &1, &2))
    y * 1000 + x * 4 + facing_score(facing)
  end

  defp facing_score(facing) do
    case facing do
      {1, 0} -> 0
      {0, 1} -> 1
      {-1, 0} -> 2
      {0, -1} -> 3
    end
  end

  def step(_monkey_map, {:turn, ?R}, {pos, facing}), do: {pos, turn_right(facing)}
  def step(_monkey_map, {:turn, ?L}, {pos, facing}), do: {pos, turn_left(facing)}
  def step(monkey_map, {:move, n}, {pos, facing}) do
    throw("not implemented")
  end


  # {1, 0} -> {0, 1} -> {-1, 0} -> {0, -1} -> {1, 0} => R {-1*y, x}
  defp turn_right({x, y}), do: {-1*y, x}
  # {1, 0} -> {0, -1} -> {-1, 0} -> {0, 1} -> {1, 0} => L {y, -1*x}
  defp turn_left({x, y}), do: {y, -1*x}

  def prepare_map(basic_map) do
    {edges_by_row, edges_by_column} = basic_map
    |> Map.keys()
    |> Enum.reduce(
      {%{}, %{}},
      fn {x, y}, {row, column} ->
        { Map.update(row, y, {x, x}, fn {min_x, max_x} -> {min(x, min_x), max(x, max_x)} end),
          Map.update(column, x, {y, y}, fn {min_y, max_y} -> {min(y, min_y), max(y, max_y)} end) }
      end)
    %MonkeyMap{map: basic_map, edges_by_row: edges_by_row, edges_by_column: edges_by_column}
  end

  def read_input(input) do
    [map_spec, instructions_spec] = Input.sections(input)
    map = Input.read_grid(map_spec, &Function.identity/1, 1, 1)
    |> Enum.filter(fn {_, c} -> c != ?\s end)
    |> Map.new
    {instructions, last_move} = instructions_spec
    |> String.to_charlist
    |> Enum.reduce(
      {[], 0},
      fn el, {result, num} ->
        if ?0 <= el && el <= ?9 do
          {result, num * 10 + (el - ?0)}
        else
          {[{:turn, el}, {:move, num} | result], 0}
        end
      end)
    {map, Enum.reverse([{:move, last_move} | instructions])}
  end
end
