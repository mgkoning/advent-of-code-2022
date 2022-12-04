defmodule Advent2022 do
  @days %{
    1 => &Advent2022.Day01.solve/1,
    2 => &Advent2022.Day02.solve/1,
    3 => &Advent2022.Day03.solve/1,
    4 => &Advent2022.Day04.solve/1,
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

  defp file_name(day), do: "../../input/day#{str_day(day)}.txt"
  defp str_day(day) when day < 10, do: "0#{day}"
  defp str_day(day), do: Integer.to_string(day)
end
