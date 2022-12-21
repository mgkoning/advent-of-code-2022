defmodule Advent2022.Day21 do
  alias Advent2022.Input
  def solve(input) do
    IO.puts("Part 1:")
    monkeys = read_monkeys(input)
    IO.puts(part1(monkeys))
    IO.puts("Part 2:")
    IO.puts(part2(monkeys))
  end

  def part1(monkeys) do
    sorted_monkeys(monkeys)
    |> get_monkey_values(monkeys)
    |> Map.get("root")
  end

  def part2(monkeys) do
    sorted = sorted_monkeys(monkeys)
    actual_monkeys = Map.update!(monkeys, "root", fn {:op, _, lhs, rhs} -> {:op, &==/2, lhs, rhs} end)
    # just trial and error (-:
    3099532691100..3099532691400
    |> Stream.map(fn h ->
      iter_map = Map.put(actual_monkeys, "humn", {:const, h})
      equals? = sorted
      |> get_monkey_values(iter_map)
      |> Map.get("root")
      {h, equals?} end)
    |> Stream.drop_while(fn {_, e} -> !e end)
    |> Enum.map(&elem(&1, 0))
    |> hd()
  end

  defp get_monkey_values(sorted, monkey_map) do
    sorted
    |> Enum.reduce(Map.new, fn m, acc ->
      Map.put(acc, m, get_monkey_value(Map.get(monkey_map, m), acc)) end)
  end

  defp get_monkey_value({:const, n}, _), do: n
  defp get_monkey_value({:op, op, lhs, rhs}, values) do
    op.(Map.fetch!(values, lhs), Map.fetch!(values, rhs))
  end

  def sorted_monkeys(monkeys) do
    no_incoming = for {m, {:const, _v}} <- monkeys, do: m
    outgoing_edges = for {m, {:op, _op, lhs, rhs}} <- monkeys, reduce: Map.new() do
      acc -> acc |> Map.update(lhs, [m], &[m|&1]) |> Map.update(rhs, [m], &[m|&1])
    end
    incoming_edges = outgoing_edges
    |> Enum.flat_map(fn {k, vs} -> Enum.map(vs, &{&1, k}) end)
    |> Enum.reduce(Map.new, fn {k, v}, acc -> Map.update(acc, k, [v], &[v|&1]) end)
    topological_sort(no_incoming, outgoing_edges, incoming_edges, MapSet.new, [])
  end

  def topological_sort([], _, _, _, sorted), do: Enum.reverse(sorted)
  def topological_sort([n | ns], outgoing_edges, incoming_edges, done, sorted) do
    new_sorted = [n | sorted]
    new_done = MapSet.put(done, n)
    neighbors_done = Map.get(outgoing_edges, n, [])
    |> Enum.filter(fn m -> Map.get(incoming_edges, m, []) |> Enum.all?(&MapSet.member?(new_done, &1)) end)
    topological_sort(ns ++ neighbors_done, outgoing_edges, incoming_edges, new_done, new_sorted)
  end

  def read_monkeys(input) do
    Input.convert_lines(input, &read_monkey/1) |> Map.new
  end
  defp read_monkey(line) do
    [monkey, job] = String.split(line, ": ")
    case Integer.parse(job) do
      {n, ""} -> {monkey, {:const, n}}
      _ ->
        [lhs, op, rhs] = Input.words(job)
        {monkey, {:op, determine_op(op), lhs, rhs}}
    end
  end
  defp determine_op(op) do
    case op do
      "*" -> &*/2
      "/" -> &div/2
      "+" -> &+/2
      "-" -> &-/2
    end
  end
end
