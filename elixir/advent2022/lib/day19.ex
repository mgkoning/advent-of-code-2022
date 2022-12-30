defmodule Advent2022.Day19 do
  defmodule State do
    defstruct bots: [ore: 1, clay: 0, obsidian: 0, geode: 0],
      resources: [ore: 0, clay: 0, obsidian: 0, geode: 0]
  end
  alias Advent2022.Input

  def solve(input) do
    IO.puts("Part 1:")
    blueprints = read_blueprints(input)
    IO.puts(part1(blueprints))
    IO.puts("Part 2:")
    IO.puts(part2(blueprints))
  end

  def part1(blueprints) do
    blueprints
    |> Enum.map(&add_max_bots/1)
    |> Enum.map(&{elem(&1, 0), maximize_production(&1, [{nil, 24, %State{}}])})
    |> IO.inspect()
    |> Enum.map(fn {id, max} -> id * max end)
    |> Enum.sum()
  end

  def part2(blueprints) do
    blueprints
    |> Enum.take(3)
    |> Enum.map(&add_max_bots/1)
    |> Enum.map(&maximize_production(&1, [{nil, 32, %State{}}]))
    |> IO.inspect()
    |> Enum.product()
  end

  def maximize_production(blueprint, states, max \\ -1)
  def maximize_production(_blueprint, [], max), do: max
  def maximize_production({_id, bots, max_bots} = blueprint, [{type, time, state} | states], max) do
    if time <= 0 do
      #IO.inspect(state)
      # out of time: the best we can do with this branch
      maximize_production(blueprint, states, max(max, Keyword.fetch!(state.resources, :geode)))
    else
      {:ok, state_after_build} = case type do
        nil -> {:ok, state}
        _ -> build_bot({type, Keyword.fetch!(bots, type)}, state)
      end
      state_after_mine = %{state_after_build | resources: mine(state.bots, state_after_build.resources)}
      max_possible = Keyword.fetch!(state_after_mine.bots, :geode) * (time-1) + div((time-2)*(time-1),2)
      if Keyword.fetch!(state_after_mine.resources, :geode) + max_possible <= max do
        # can't be better: skip this branch
        maximize_production(blueprint, states, max)
      else
        bots_to_try = bots
        |> Enum.filter(fn {type, requirements} ->
          Keyword.get(state_after_mine.bots, type) < Keyword.get(max_bots, type)
          && can_build(requirements, state_after_mine.resources) end)
        |> Enum.map(&elem(&1, 0))
        |> Enum.reverse()
        next_states = (bots_to_try ++ [nil])
        |> Enum.map(fn type -> {type, time-1, state_after_mine} end)

        maximize_production(blueprint, next_states ++ states, max)
      end
    end
  end

  defp can_build(requirements,resources) do
    requirements
    |> Enum.all?(fn {type, number} -> number <= Keyword.fetch!(resources, type) end)
  end
  defp build_bot({bot_type, requirements}, %State{resources: resources} = state) do
    resources_after_build = requirements
    |> Enum.reduce(resources, fn {type, number}, acc -> Keyword.update!(acc, type, & &1 - number) end)
    if Enum.all?(resources_after_build, fn {_type, number} -> 0 <= number end) do
      {:ok, %{state | bots: Keyword.update(state.bots, bot_type, 1, & &1 + 1), resources: resources_after_build}}
    else
      {:nope}
    end
  end

  defp mine(bots, resources) do
    bots
    |> Enum.reduce(resources, fn {type, n}, acc -> Keyword.update!(acc, type, & &1 + n) end)
  end

  def add_max_bots({_id, bots} = blueprint) do
    maxes = bots
    |> Enum.reduce([], fn {_type, req}, a ->
      Enum.reduce(req, a, fn {type, n}, acc -> Keyword.update(acc, type, n, &max(&1, n)) end) end)
    Tuple.append(blueprint, maxes)
  end

  def read_blueprints(input) do
    Input.convert_lines(input, &read_blueprint/1)
  end

  def read_blueprint(line) do
    [name, spec] = String.split(line, ": ")
    id = name |> String.slice(10, 2) |> String.to_integer()
    [[_, _, _, _, ore_bot_ore, _],
     [_, _, _, _, clay_bot_ore, _],
     [_, _, _, _, obs_bot_ore, _, _, obs_bot_clay ,_],
     [_, _, _, _, geode_bot_ore, _, _, geode_bot_obsidian, _]] =
      String.split(spec,  ". ") |> Enum.map(&Input.words/1)
    {
      id, [
        {:ore, [ore: String.to_integer(ore_bot_ore)]},
        {:clay, [ore: String.to_integer(clay_bot_ore)]},
        {:obsidian, [ore: String.to_integer(obs_bot_ore), clay: String.to_integer(obs_bot_clay)]},
        {:geode, [ore: String.to_integer(geode_bot_ore), obsidian: String.to_integer(geode_bot_obsidian)]},]}
  end
end
