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

  def read_grid(input, convert_char, offset_y \\ 0, offset_x \\ 0) do
    grid = input
    |> lines
    |> Enum.with_index(offset_y)
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.to_charlist
      |> Enum.with_index(offset_x)
      |> Enum.map(fn {c, x} -> {{x, y}, convert_char.(c)} end)
    end)
    Enum.into(grid, %{})
  end
end
