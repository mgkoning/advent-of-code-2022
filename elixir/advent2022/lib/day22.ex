defmodule Advent2022.Day22 do
  alias Advent2022.Input
  alias Advent2022.Coord

  defmodule MonkeyMap do
    defstruct map: %{}, edges_by_row: %{}, edges_by_column: %{}
  end
  @right {1, 0}
  @down {0, 1}
  @left {-1, 0}
  @up {0, -1}

  def solve(input) do
    {basic_map, instructions} = read_input(input)
    monkey_map = prepare_map(basic_map)
    IO.puts("Part 1:")
    IO.puts(part1(monkey_map, instructions))
    IO.puts("Part 2:")
    IO.puts(part2(monkey_map, instructions))
  end

  def part1(monkey_map, instructions) do
    {start_pos, _} = Map.fetch!(monkey_map.edges_by_row, 1)
    {{x, y}, facing} = instructions
    |> Enum.reduce({{start_pos, 1}, @right}, fn el, acc -> step(monkey_map, &wrap_plane/3, el, acc) end)
    y * 1000 + x * 4 + facing_score(facing)
  end
  def part2(monkey_map, instructions) do
    {start_pos, _} = Map.fetch!(monkey_map.edges_by_row, 1)
    {{x, y}, facing} = instructions
    |> Enum.reduce({{start_pos, 1}, @right}, fn el, acc -> step(monkey_map, &wrap_cube/3, el, acc) end)
    y * 1000 + x * 4 + facing_score(facing)
  end

  defp facing_score(facing) do
    case facing do
      @right -> 0
      @down -> 1
      @left -> 2
      @up -> 3
    end
  end

  def step(_monkey_map, _, {:turn, ?R}, {pos, facing}), do: {pos, turn_right(facing)}
  def step(_monkey_map, _, {:turn, ?L}, {pos, facing}), do: {pos, turn_left(facing)}
  def step(monkey_map, wrap_fn, {:move, n}, pos) do
    1..n
    |> Stream.scan(pos, fn _, acc -> move_with_wrap(acc, monkey_map, wrap_fn) end)
    |> Enum.take_while(&Map.fetch!(monkey_map.map, elem(&1, 0)) != ?#)
    |> List.last(pos)
  end

  defp move_with_wrap({pos, facing}, monkey_map, wrap_fn) do
    new_pos = Coord.add(pos, facing)
    if Map.has_key?(monkey_map.map, new_pos), do: {new_pos, facing}, else: wrap_fn.(new_pos, facing, monkey_map)
  end
  defp wrap_plane({x, y}, {0, _dy} = facing, %MonkeyMap{edges_by_column: edges}) do
    {min, max} = Map.fetch!(edges, x)
    pos = if y < min, do: {x, max}, else: {x, min}
    {pos, facing}
  end
  defp wrap_plane({x, y}, {_dx, 0} = facing, %MonkeyMap{edges_by_row: edges}) do
    {min, max} = Map.fetch!(edges, y)
    pos = if x < min, do: {max, y}, else: {min, y}
    {pos, facing}
  end
  # I suppose this isn't necessary, but I'm not sure how to automatically determine
  # translation between faces, so this is hardcoded for how my part 2 map looks:
  #  12
  #  3
  # 45
  # 6
  defp wrap_cube(pos, _, _) do
    case pos do
      # 1 -> 6
      {x, y} when y == 0 and 50 < x and x < 101 -> {{1, 151 + x - 51}, @right}
      # 1 -> 4
      {x, y} when x == 50 and 0 < y and y < 51 -> {{1, 150 - (y - 1)}, @right}
      # 2 -> 6
      {x, y} when y == 0 and 100 < x and x < 151 -> {{1 + x - 101, 200}, @up}
      # 2 -> 3
      {x, y} when y == 51 and 100 < x and x < 151 -> {{100, 51 + x - 101}, @left}
      # 2 -> 5
      {x, y} when x == 151 and 0 < y and y < 51 -> {{100, 150 - (y - 1)}, @left}
      # 3 -> 4
      {x, y} when x == 50 and 50 < y and y < 101 -> {{1 + y - 51, 101}, @down}
      # 3 -> 2
      {x, y} when x == 101 and 50 < y and y < 101 -> {{101 + y - 51, 50}, @up}
      # 4 -> 3
      {x, y} when y == 100 and 0 < x and x < 51 -> {{51, 51 + x - 1}, @right}
      # 4 -> 1
      {x, y} when x == 0 and 100 < y and y < 151 -> {{51, 50 - (y - 101)}, @right}
      # 5 -> 2
      {x, y} when x == 101 and 100 < y and y < 151 -> {{150, 50 - (y - 101)}, @left}
      # 5 -> 6
      {x, y} when y == 151 and 50 < x and x < 101 -> {{50, 151 + x - 51}, @left}
      # 6 -> 1
      {x, y} when x == 0 and 150 < y and y < 201 -> {{51 + y - 151, 1}, @down}
      # 6 -> 2
      {x, y} when y == 201 and 0 < x and x < 51 -> {{101 + x - 1, 1}, @down}
      # 6 -> 5
      {x, y} when x == 51 and 150 < y and y < 201 -> {{51 + y - 151, 150}, @up}
      {x, y} -> throw "whoops (#{x}, #{y})"
    end
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
