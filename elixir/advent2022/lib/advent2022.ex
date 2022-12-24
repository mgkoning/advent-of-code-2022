defmodule Advent2022 do
  @days %{
    1 => &Advent2022.Day01.solve/1,
    2 => &Advent2022.Day02.solve/1,
    3 => &Advent2022.Day03.solve/1,
    4 => &Advent2022.Day04.solve/1,
    5 => &Advent2022.Day05.solve/1,
    6 => &Advent2022.Day06.solve/1,
    7 => &Advent2022.Day07.solve/1,
    8 => &Advent2022.Day08.solve/1,
    9 => &Advent2022.Day09.solve/1,
    10 => &Advent2022.Day10.solve/1,
    11 => &Advent2022.Day11.solve/1,
    12 => &Advent2022.Day12.solve/1,
    13 => &Advent2022.Day13.solve/1,
    14 => &Advent2022.Day14.solve/1,
    15 => &Advent2022.Day15.solve/1,
    16 => &Advent2022.Day16.solve/1,
    17 => &Advent2022.Day17.solve/1,
    18 => &Advent2022.Day18.solve/1,
    19 => &Advent2022.Day19.solve/1,
    20 => &Advent2022.Day20.solve/1,
    21 => &Advent2022.Day21.solve/1,
    22 => &Advent2022.Day22.solve/1,
    23 => &Advent2022.Day23.solve/1,
    24 => &Advent2022.Day24.solve/1,
  }

  def main(argv) do
    day = determine_day(argv)
    IO.puts("Running for day #{day}")
    {:ok, runner} = Map.fetch(@days, day)
    {:ok, input} = File.read(file_name(day))
    runner.(input)
  end

  def determine_day([]) do
    {:ok, %DateTime{day: day}} = DateTime.now("Europe/Amsterdam", Tz.TimeZoneDatabase)
    day
  end

  def determine_day([arg0 | _]) do
    {i, _} = Integer.parse(arg0)
    i
  end

  defp file_name(day) do
    "../../input/day#{Integer.to_string(day) |> String.pad_leading(2, ["0"])}.txt"
  end
end
