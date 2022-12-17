defmodule Advent2022.Day16 do
  alias Advent2022.Input
  alias Advent2022.Common

  def solve(input) do
    IO.puts("Part 1:")
    valve_map = read_valves(input)
    part1(valve_map)
    |> IO.puts()
  end

  def part1(valve_map) do
    relevant_valves = find_relevant_valves(valve_map)
    tunnel_map = valve_map
    |> Enum.map(fn {name, {_, connections}} -> {name, connections} end)
    |> Map.new
    flow_map = valve_map
    |> Enum.map(fn {name, {flow, _}} -> {name, flow} end)
    |> Map.new
    graph_distances = Enum.concat(["AA"], relevant_valves)
    |> Enum.map(&{&1, all_distances(&1, tunnel_map)})
    |> Enum.map(fn {from, distance_map} ->
       {from, distance_map
                |> Enum.filter(fn {to, _} -> MapSet.member?(relevant_valves, to) end)} end)
    |> Map.new
    maximum_flow("AA", 30, graph_distances, flow_map)
  end

  def maximum_flow(from, time, graph_distances, flow_map, visited \\ MapSet.new)
  def maximum_flow(_, n, _, _, _) when n <= 0, do: 0
  def maximum_flow(from, n, graph_distances, flow_map, visited) do
    flow = Map.get(flow_map, from, 0)
    time_remaining = n - (if 0 < flow, do: 1, else: 0)
    neighbors = Map.get(graph_distances, from, [])
    |> Enum.filter(fn {n, dist} -> !MapSet.member?(visited, n) && dist < time_remaining end)
    new_visited = MapSet.put(visited, from)
    flow = Map.get(flow_map, from, 0)
    time_remaining = n - (if 0 < flow, do: 1, else: 0)
    max_flow_further = neighbors
    |> Enum.map(fn {to, dist} ->
                  maximum_flow(to, time_remaining-dist, graph_distances, flow_map, new_visited) end)
    |> Enum.max(&>=/2, fn -> 0 end)
    max_flow_further + flow * time_remaining
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
