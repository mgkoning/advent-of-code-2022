defmodule Advent2022.Day07 do
  alias Advent2022.Input

  def solve(input) do
    tree = build_directory_tree(input)
    IO.puts("Part 1:")
    {top_size, _} = disk_usage = determine_disk_usage(tree)
    disk_usage_list = disk_usage |> tree_to_list()
    IO.puts(disk_usage_list |> Enum.filter(fn s -> s <= 100000 end) |> Enum.sum())
    IO.puts("Part 2:")
    total_size = 70000000
    required_size = 30000000
    needed = required_size - (total_size - top_size)
    IO.puts(disk_usage_list |> Enum.filter(fn s -> needed <= s end) |> Enum.sort() |> Enum.fetch!(0))
  end

  def tree_to_list({size, subtree}) do
    [size | Map.values(subtree) |> Enum.flat_map(&tree_to_list/1)]
  end

  def determine_disk_usage({size, subtree}) do
    subtree_sizes = Enum.map(subtree, fn {k, v} -> {k, determine_disk_usage(v)} end) |> Enum.into(%{})
    subtree_size_sum = subtree_sizes
    |> Map.values()
    |> Enum.map(fn {size, _} -> size end)
    |> Enum.sum()
    {size + subtree_size_sum, subtree_sizes}
  end

  def build_directory_tree(input) do
    {_cwd, tree} = input
    |> Input.lines()
    |> Stream.map(&Input.words/1)
    |> Enum.reduce({[], {0, %{}}}, &process_line/2)
    tree
  end

  defp process_line(["$", "cd", "/"], {_, result}), do: {[], result}
  defp process_line(["$", "cd", ".."], {[_ | dir], result}), do: {dir, result}
  defp process_line(["$", "cd", dir], {cwd, result}), do: {[dir | cwd], result}
  defp process_line(["$", "ls"], acc), do: acc
  defp process_line(["dir", _], acc), do: acc
  defp process_line([size, _name], {cwd, result}) do
    {cwd, insert_file(Enum.reverse(cwd), String.to_integer(size), result)}
  end

  defp insert_file([], size, {cur_size, subdirs}), do: {cur_size + size, subdirs}
  defp insert_file([d | dirs], size, {cur_size, subdirs}) do
    {cur_size, Map.put(subdirs, d, insert_file(dirs, size, Map.get(subdirs, d, {0, %{}})))}
  end
end
