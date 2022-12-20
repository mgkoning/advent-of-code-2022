defmodule Advent2022.Input do
  def sections(value), do: String.split(value, "\n\n")
  def lines(value), do: String.split(value, "\n")
  def convert_lines(value, line_mapper) do
    value
    |> lines()
    |> Enum.map(&line_mapper.(&1))
  end
  def words(value), do: String.split(value)

  def tuple(value, pattern, map_elements_fn \\ fn x -> x end) do
    value
    |> String.split(pattern)
    |> Enum.map(&map_elements_fn.(&1))
    |> List.to_tuple()
  end

  def coord(value) do
    tuple(value, ",", &String.to_integer/1)
  end
end
