defmodule Advent2022.Day25 do
  alias Advent2022.Input
  def solve(input) do
    IO.puts("Part 1:")
    IO.puts(read_snafus(input) |> Enum.sum() |> to_snafu())
  end

  def to_snafu(num, acc \\ [])
  def to_snafu(0, acc), do: acc |> List.to_string()
  def to_snafu(num, acc) do
    {digit, carry} = to_snafu_digit(rem(num, 5))
    to_snafu(div(num, 5) + carry, [digit | acc])
  end
  def to_snafu_digit(n) when 0 <= n and n < 3, do: {?0 + n, 0}
  def to_snafu_digit(3), do: {?=, 1}
  def to_snafu_digit(4), do: {?-, 1}

  def read_snafus(input) do
    Input.convert_lines(input, &parse_snafu/1)
  end
  defp parse_snafu(line) do
    digit_value = fn
      ?0 -> 0
      ?1 -> 1
      ?2 -> 2
      ?- -> -1
      ?= -> -2 end
    line
    |> String.to_charlist()
    |> Enum.reduce(0, fn el, acc -> acc * 5 + digit_value.(el) end)
  end
end
