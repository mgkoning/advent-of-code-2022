defmodule Advent2022.Day06 do
  def solve(input) do
    chars = String.to_charlist(input)
    IO.puts("Part 1:")
    IO.puts(find_marker(4, chars, 0))
    IO.puts("Part 2:")
    IO.puts(find_marker(14, chars, 0))
  end

  defp find_marker(_, [], _), do: -1
  defp find_marker(required_size, stream, processed) do
    case stream |> Enum.take(required_size) |> Enum.uniq() |> Enum.count() do
      ^required_size -> processed + required_size
      _ -> find_marker(required_size, Enum.drop(stream, 1), processed + 1)
    end
  end
end
