defmodule Advent2022.Day11 do
  alias Advent2022.Input
  defmodule Monkey do
    defstruct operation: &(&1 + &2), rhs: 0, test_divisor: 1, target_true: -1, target_false: -1
  end

  def solve(input) do
    monkey_map = read_monkeys(input)
    IO.puts("Part 1:")
    IO.puts(part1(monkey_map))
    IO.puts("Part 2:")
    IO.puts(part2(monkey_map))
  end

  def part1(monkey_map) do
    run_part(monkey_map, 20, &div(&1, 3))
  end

  def part2(monkey_map) do
    divisor_product = Enum.map(monkey_map, fn {_, {_, %Monkey{test_divisor: divisor}, _}} -> divisor end) |> Enum.product()
    run_part(monkey_map, 10000, &rem(&1, divisor_product))
  end

  def run_part(monkey_map, rounds, manage_worry_level) do
    keys = Map.keys(monkey_map) |> Enum.sort()
    [last_round] = Stream.iterate(monkey_map, &run_round(keys, &1, manage_worry_level))
    |> Stream.drop(rounds)
    |> Enum.take(1)
    last_round
    |> Map.values()
    |> Enum.map(&elem(&1, 2))
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  def run_round(keys, monkey_map, manage_worry_level) do
    Enum.reduce(keys, monkey_map, fn id, map ->
      {new_monkey, thrown} = run_turn(Map.fetch!(map, id), manage_worry_level)
      Enum.reduce(thrown, Map.put(map, id, new_monkey), fn {id_rec, items}, acc ->
        Map.update!(acc, id_rec, fn {cur_items, m, c} -> {items ++ cur_items, m, c} end)
      end)
    end)
  end

  def run_turn({items, monkey, inspections}, manage_worry_level) do
    thrown_map = Enum.reverse(items) |> Enum.reduce(%{}, fn i, thrown_map ->
      {target, worry_level} = monkey_inspect(i, monkey, manage_worry_level)
      Map.update(thrown_map, target, [worry_level], fn other -> [worry_level | other] end)
    end)
    new_monkey = {[], monkey, inspections + Enum.count(items)}
    {new_monkey, Map.to_list(thrown_map)}
  end

  def monkey_inspect(worry_level, monkey, manage_worry_level) do
    %Monkey{
      operation: op, rhs: rhs, test_divisor: test_divisor,
       target_false: target_false, target_true: target_true} = monkey
    new_worry_level = manage_worry_level.(run_op(worry_level, op, rhs))
    {(if rem(new_worry_level, test_divisor) == 0, do: target_true, else: target_false), new_worry_level}
  end

  def run_op(lhs, op, rhs) do
    val_rhs = if rhs == :old, do: lhs, else: rhs
    op.(lhs, val_rhs)
  end

  def read_monkeys(input) do
    input
    |> Input.sections()
    |> Enum.map(&read_monkey/1)
    |> Enum.into(%{})
  end

  defp read_monkey(input) do
    [lid, litems, loperation, ltest, ltrue, lfalse] = Input.lines(input)
    id = String.at(lid, 7) |> String.to_integer()
    items = String.split(litems, ": ")
    |> List.last()
    |> String.split(", ")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reverse()
    [wrhs, op | _] = Input.words(loperation) |> Enum.reverse()
    last_as_integer = fn l -> Input.words(l) |> List.last() |> String.to_integer() end
    monkey = %Monkey{
      operation: (if op == "+", do: &(&1 + &2), else: &(&1 * &2)),
      rhs: (if wrhs == "old", do: :old, else: String.to_integer(wrhs)),
      test_divisor: last_as_integer.(ltest),
      target_true: last_as_integer.(ltrue),
      target_false: last_as_integer.(lfalse)}
    {id, {items, monkey, 0}}
  end
end
