defmodule Advent2022.Day09 do
  alias Advent2022.Input

  def solve(input) do
    instructions = read_instructions(input)
    IO.puts("Part 1:")
    tail_visits_1 = sim_rope(instructions, 2)
    IO.puts(tail_visits_1 |> Enum.count())
    # show_tail_visits(tail_visits_1)
    IO.puts("Part 2:")
    tail_visits_2 = sim_rope(instructions, 10)
    IO.puts(tail_visits_2 |> Enum.count())
    # show_tail_visits(tail_visits_2)
  end

  @origin { 0, 0 }
  defp sim_rope(instructions, rope_size) do
    knots = List.duplicate(@origin, rope_size)
    {_, tail_visits} = for ins <- instructions, reduce: {knots, MapSet.new()} do
      { [head | knots], tail_visits } ->
        new_head = move(head, ins)
        [new_tail | _] = new_knots = List.foldl(
          knots,
          [new_head],
          fn k, [target | _] = acc -> [keep_up(k, target) | acc] end)
        {Enum.reverse(new_knots), MapSet.put(tail_visits, new_tail)}
    end
    tail_visits
  end

  defp move({x, y}, "L"), do: {x-1, y}
  defp move({x, y}, "R"), do: {x+1, y}
  defp move({x, y}, "U"), do: {x, y-1}
  defp move({x, y}, "D"), do: {x, y+1}

  defp keep_up({x_t, y_t} = tail_pos, {x_h, y_h}) do
    x_lag = x_h - x_t
    y_lag = y_h - y_t
    case {abs(x_lag), abs(y_lag)} do
      {dx, dy} when dx <= 1 and dy <= 1 -> tail_pos
      {0, dy} -> {x_t, y_t + div(y_lag, dy)}
      {dx, 0} -> {x_t + div(x_lag, dx), y_t}
      {dx, dy} -> {x_t + div(x_lag, dx), y_t + div(y_lag, dy)}
    end
  end

  defp read_instructions(input) do
    input
    |> Input.lines()
    |> Stream.flat_map(fn line ->
      [dir, count] = Input.words(line)
      List.duplicate(dir, String.to_integer(count)) end)
  end

  # Just for fun
  defp show_tail_visits(visits) do
    xs = visits |> Enum.map(&elem(&1, 0))
    ys = visits |> Enum.map(&elem(&1, 1))
    for y <- Enum.min(ys)..Enum.max(ys) do
      Enum.min(xs)..Enum.max(xs)
      |> Enum.map(fn x -> if MapSet.member?(visits, {x, y}), do: ?#, else: ?. end)
      |> List.to_string()
      |> IO.puts()
    end
  end
end
