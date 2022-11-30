defmodule Advent2022 do
  @days %{
    1 => &Advent2022.Day01.solve/1
  }

  def main(argv) do
    day = determine_day(argv)
    IO.puts("Running for day #{day}")
    {:ok, runner} = Map.fetch(@days, day)
    {:ok, input} = File.read(file_name(day))
    runner.(input)
  end

  defp determine_day([]) do
    {:ok, %DateTime{day: day}} = DateTime.now("Europe/Amsterdam", Tz.TimeZoneDatabase)
    day
  end

  defp determine_day([arg0 | _]) do
    {i, _} = Integer.parse(arg0)
    i
  end

  defp file_name(day), do: "../../input/day#{str_day(day)}.txt"
  defp str_day(day) when day < 10, do: "0#{day}"
  defp str_day(day), do: Integer.to_string(day)
end
