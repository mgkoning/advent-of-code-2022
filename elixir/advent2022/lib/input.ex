defmodule Advent2022.Input do
  def lines(value), do: String.split(value, ~r/\n/)
  def words(value), do: String.split(value)

  def tuple(value, pattern, map_elements_fn \\ fn x -> x end) do
    value
    |> String.split(pattern)
    |> Enum.map(&map_elements_fn.(&1))
    |> List.to_tuple()
  end

  def enumerated(enumerable, from \\ 0) do
    Stream.zip(Stream.iterate(from, &(&1 + 1)), enumerable)
  end
end
