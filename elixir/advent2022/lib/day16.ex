defmodule Advent2022.Day16.State do
  defstruct from: "AA", time: 0, distances: nil, flow_map: nil, visited: MapSet.new
end

defmodule Advent2022.Day16 do
  alias Advent2022.Input
  alias Advent2022.Common
  alias Advent2022.Day16.State

  def solve(input) do
    IO.puts("Part 1:")
    {flow_map, distances} = read_valves(input)
    |> prepare_map()
    part1(flow_map, distances) |> IO.puts()
    IO.puts("Part 2:")
    part2(flow_map, distances) |> IO.puts()
  end

  def part1(flow_map, distances) do
    maximum_flow(%State{time: 30, distances: distances, flow_map: flow_map}) |> elem(0)
  end

  def part2(flow_map, distances) do
    start_state = %State{time: 26, distances: distances, flow_map: flow_map}
    {max_self, path} = maximum_flow(start_state)
    {max_elephant, _} = maximum_flow(%{start_state | visited: MapSet.new(path)})
    max_self + max_elephant
  end

  def maximum_flow(%State{time: time}) when time <= 0, do: {0, []}
  def maximum_flow(%State{from: from, time: time, visited: visited} = state) do
    new_visited = MapSet.put(visited, from)

    flow = Map.get(state.flow_map, from, 0)
    time_remaining = time - (if 0 < flow, do: 1, else: 0)
    neighbors = Map.get(state.distances, from, [])
    |> Enum.filter(fn {n, dist} -> !MapSet.member?(new_visited, n) && dist < time_remaining end)

    {max_flow_further, path_further} = neighbors
    |> Enum.map(fn {to, dist} ->
      maximum_flow(%{state | from: to, time: time_remaining-dist, visited: new_visited}) end)
    |> Enum.max_by(&elem(&1, 0), &>=/2, fn -> {0, []} end)
    {max_flow_further + flow * time_remaining, [from | path_further]}
  end

  def prepare_map(valve_map) do
    relevant_valves = find_relevant_valves(valve_map)
    tunnel_map = valve_map
    |> Enum.map(fn {name, {_, connections}} -> {name, connections} end)
    |> Map.new
    flow_map = valve_map
    |> Enum.map(fn {name, {flow, _}} -> {name, flow} end)
    |> Map.new
    distances = Enum.concat(["AA"], relevant_valves)
    |> Enum.map(&{&1, all_distances(&1, tunnel_map)})
    |> Enum.map(fn {from, distance_map} ->
      relevant_distances = distance_map
      |> Enum.filter(fn {to, _} -> MapSet.member?(relevant_valves, to) end)
      {from, relevant_distances} end)
    |> Map.new
    {flow_map, distances}
  end

  def all_distances(from, tunnel_map) do
    distances = Map.keys(tunnel_map) |> Enum.map(&{&1, 1000000000}) |> Enum.into(Map.new)
    determine_shortest_paths(tunnel_map, distances, [{from, 0}], MapSet.new)
    |> Map.delete(from)
  end

  def determine_shortest_paths(_, distances, [], _), do: distances
  def determine_shortest_paths(tunnel_map, distances, [{next, distance} | to_visit], visited) do
    neighbors = Map.get(tunnel_map, next, [])
    |> Enum.filter(& !MapSet.member?(visited, &1))
    |> Enum.map(&{&1, distance + 1})
    determine_shortest_paths(
      tunnel_map,
      Map.update(distances, next, distance, &min(&1, distance)),
      neighbors |> Enum.reduce(to_visit, &Common.insert_sorted(&2, &1)),
      neighbors |> Enum.reduce(visited, fn {n, _}, acc -> MapSet.put(acc, n) end))
  end

  def find_relevant_valves(valve_map) do
    valve_map
    |> Enum.filter(fn {_, {r, _}} -> 0 < r end)
    |> Enum.map(&elem(&1, 0))
    |> MapSet.new
  end

  def read_valves(input) do
    input
    |> Input.lines()
    |> Enum.map(&read_valve/1)
    |> Map.new()
  end

  defp read_valve(line) do
    [_, name, _, _, _, flow_rate, _, _, _, _ | tunnels] = String.split(line, ~r/([;,]? |=)/)
    {name, {String.to_integer(flow_rate), tunnels}}
  end
end
