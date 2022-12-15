defmodule Advent2022.Day15 do
  alias Advent2022.Input

  def solve(input) do
    IO.puts("Part 1:")
    sensors_and_beacons = read_sensors_and_beacons(input)
    IO.puts(no_beacons(sensors_and_beacons, 2_000_000))
    IO.puts("Part 2:")
    IO.puts(find_gap(sensors_and_beacons, 0..4_000_000))
  end

  def find_gap(sensors_and_beacons, range) do
    [{[from_r.._ | _], y} | _] = range
    |> Stream.map(fn y ->
      ranges = covered_ranges(sensors_and_beacons, y)
      |> Enum.map(&clamp(&1, range))
      {ranges, y}
    end)
    |> Stream.drop_while(&Enum.count(elem(&1, 0)) < 2)
    |> Enum.take(1)
    4_000_000 * (from_r-1) + y
  end

  def clamp(from..to, min..max) do
    max(from, min)..min(to, max)
  end

  def no_beacons(sensors_and_beacons, y) do
    overlaps = sensors_and_beacons
    |> covered_ranges(y)
    |> Enum.map(&Range.size/1)
    |> Enum.sum()
    beacons_at = sensors_and_beacons
    |> Enum.map(&elem(&1, 1))
    |> Enum.filter(&elem(&1, 1) == y)
    |> Enum.uniq()
    |> Enum.count()
    overlaps - beacons_at
  end

  def covered_ranges(sensors_and_beacons, y) do
    sensors_and_beacons
    |> Enum.map(&overlap_with(&1, y))
    |> Enum.filter(&(0 < Range.size(&1)))
    |> Enum.sort_by(fn from.._to -> from end)
    |> Enum.reduce([], &add_range/2)
  end

  def add_range(range, []), do: [range]
  def add_range(new_from..new_to = current_range, [prev_from..prev_to = range | ranges]) do
    if prev_to + 1 < new_from do
      [current_range, range | ranges]
    else
      [prev_from..max(new_to, prev_to) | ranges]
    end
  end

  def overlap_with({{sx, sy} = sensor, beacon}, line_y) do
    sensor_range = manhattan_distance(sensor, beacon)
    distance_y = abs(sy - line_y)
    range_x = sensor_range - distance_y
    if range_x < 0, do: .., else: (sx - range_x)..(sx + range_x)
  end

  def manhattan_distance({x0, y0}, {x1, y1}) do
    abs(x0 - x1) + abs(y0 - y1)
  end

  def read_sensors_and_beacons(input) do
    input
    |> Input.lines()
    |> Enum.map(&read_sensor_and_beacon/1)
  end

  def read_sensor_and_beacon(line) do
    [sensor_spec, beacon_spec] = String.split(line, ": ")
    [sensor_x, s_y] = String.split(sensor_spec, ", y=")
    s_x = String.slice(sensor_x, 12..-1)
    [beacon_x, b_y] = String.split(beacon_spec, ", y=")
    b_x = String.slice(beacon_x, 23..-1)
    [s_x, s_y, b_x, b_y]
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
    |> List.to_tuple()
  end

end
