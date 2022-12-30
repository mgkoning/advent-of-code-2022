defmodule Advent2022.Day19.Test do
  use ExUnit.Case
  import Advent2022.Day19

  @sample_input "Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian."

  test "part 1" do
    blueprints = read_blueprints(@sample_input)
    assert part1(blueprints) == 33
  end

  @tag timeout: 300000
  test "part 2" do
    blueprints = read_blueprints(@sample_input)
    assert part2(blueprints) == 62 * 56
  end
end
