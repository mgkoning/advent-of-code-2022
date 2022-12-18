defmodule Advent2022.Day18 do
  alias Advent2022.Input
  def solve(input) do
    IO.puts("Part 1:")
    cubes = read_cubes(input)
    {all_free_sides, count} = part1(cubes)
    IO.puts(count)
    IO.puts("Part 2:")
    IO.puts(part2(cubes, all_free_sides))
  end

  def part1(cubes) do
    cube_set = MapSet.new(cubes)
    all_free_sides = cubes
    |> Enum.flat_map(&free_sides(&1, cube_set))
    {all_free_sides, Enum.count(all_free_sides)}
  end

  def free_sides(cube, cube_set) do
    sides(cube)
    |> Enum.filter(&!MapSet.member?(cube_set, &1))
  end

  @neighbor_directions [{1,0,0}, {-1,0,0}, {0,1,0}, {0,-1,0}, {0,0,1}, {0,0,-1}]
  def sides(cube), do: Enum.map(@neighbor_directions, &add(cube, &1))

  defp add({x0, y0, z0}, {x1, y1, z1}), do: {x0+x1, y0+y1, z0+z1}

  def part2(cubes, all_free_sides) do
    # First, determine which cubes are unenclosed: these are on the outside. From there,
    # some other cubes may still be reachable. We then determine which of the possibly
    # enclosed cubes are reachable by starting from the unenclosed cubes and marking their
    # neighbors until there are no reachable cubes left. The remaining cubes must be
    # the enclosed cubes. Remove all sides that are connected to these enclosed cubes
    # for the answer to part 2.
    free_cubes_set = MapSet.new(all_free_sides)
    unenclosed = find_outer(cubes, free_cubes_set)
    possibly_enclosed = free_cubes_set
    |> Enum.filter(&!MapSet.member?(unenclosed, &1))
    |> MapSet.new
    enclosed = mark_all_reachable(MapSet.to_list(unenclosed), possibly_enclosed)
    all_free_sides |> Enum.filter(&!MapSet.member?(enclosed, &1)) |> Enum.count()
  end

  def find_outer(cubes, free_cubes_set) do
    # Possibly wasteful: determine the outer cubes per axis-aligned cross section. Any point that
    # is outside of those cubes must be on the outside of the droplet and thus unenclosed.
    xy_map = cubes |> min_max_map(fn {x, y, _z} -> {x, y} end, fn {_x, _y, z} -> z end)
    xz_map = cubes |> min_max_map(fn {x, _y, z} -> {x, z} end, fn {_x, y, _z} -> y end)
    yz_map = cubes |> min_max_map(fn {_x, y, z} -> {y, z} end, fn {x, _y, _z} -> x end)
    free_cubes_set
    |> Enum.filter(fn {x, y, z} ->
      !enclosed?(xy_map, {x, y}, z)
      or !enclosed?(xz_map, {x, z}, y)
      or !enclosed?(yz_map, {y, z}, x) end)
    |> MapSet.new
  end

  def mark_all_reachable([], enclosed), do: enclosed
  def mark_all_reachable([cube | cubes], possibly_enclosed) do
    reachable = sides(cube) |> Enum.filter(&MapSet.member?(possibly_enclosed, &1))
    mark_all_reachable(
      cubes ++ reachable,
      Enum.reduce(reachable, possibly_enclosed, fn el, acc -> MapSet.delete(acc, el) end))
  end

  defp min_max_map(enumerable, group_fn, value_fn) do
    enumerable
    |> Enum.group_by(group_fn, value_fn)
    |> Map.new(fn {k, v} -> {k, Enum.min_max(v)} end)
  end

  def enclosed?(plane_map, plane, point) do
    case Map.fetch(plane_map, plane) do
      {:ok, {min, max}} -> min < point && point < max
      :error -> false
    end
  end

  def read_cubes(input) do
    input
    |> Input.lines()
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn triple -> triple |> Enum.map(&String.to_integer/1) |> List.to_tuple() end)
  end
end
