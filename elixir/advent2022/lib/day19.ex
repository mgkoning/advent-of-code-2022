defmodule Advent2022.Day19 do
  defmodule State do
    defstruct bots: [ore: 1, clay: 0, obsidian: 0, geode: 0],
      resources: [ore: 0, clay: 0, obsidian: 0, geode: 0]
  end
  alias Advent2022.Input

  def solve(input) do
    IO.puts("Part 1:")
    blueprints = read_blueprints(input)
    IO.inspect(part1(blueprints))
  end

  def part1(blueprints) do
    blueprints
    |> Enum.map(&{elem(&1, 0), maximize_production(&1, 8, %State{})})
    |> Enum.max_by(&{elem(&1, 1)})
  end

  def maximize_production(_blueprint, time, state) when time <= 0, do: Keyword.get(state.resources, :geode)
  def maximize_production({_id, bots} = blueprint, time, state) do
    with_bots = for {:ok, {new_bots, new_resources}} <- Enum.map(bots, &build_bot(&1, state)) do
      maximize_production(blueprint, time-1, %{state | bots: new_bots, resources: mine(state.bots, new_resources)})
    end
    Enum.max([maximize_production(blueprint, time-1, %{state | resources: mine(state.bots, state.resources)}) | with_bots])
  end

  defp build_bot({bot_type, requirements}, %State{resources: resources} = state) do
    resources_after_build = requirements
    |> Enum.reduce(resources, fn {type, number}, acc -> Keyword.update!(acc, type, & &1 - number) end)
    if Enum.all?(resources_after_build, fn {_type, number} -> 0 <= number end) do
      {:ok, {Keyword.update(state.bots, bot_type, 1, & &1 + 1), resources_after_build}}
    else
      {:nope}
    end
  end

  defp mine(bots, resources) do
    bots
    |> Enum.reduce(resources, fn {type, n}, acc -> Keyword.update!(acc, type, & &1 + n) end)
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
