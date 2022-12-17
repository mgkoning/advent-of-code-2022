defmodule Rock do
  defstruct rocks: [], name: ""
end

defmodule Zipper do
  @enforce_keys [:next]
  defstruct next: [], prev: [], show_cycle?: false

  def advance(%Zipper{next: [n], prev: ps, show_cycle?: show_cycle?} = zipper) do
    if show_cycle?, do: IO.puts("cycling")
    %{zipper | next: Enum.reverse([n | ps]), prev: []}
  end
  def advance(%Zipper{next: [n | ns], prev: ps} = zipper) do
    %{zipper | next: ns, prev: [n | ps]}
  end
end

defmodule SimState do
  defstruct jets: nil, rocks: nil, filled: MapSet.new,
    position: {0, 0}, highest: 0, rocks_done: 0
end

defmodule Advent2022.Day17 do
  @rocks %Zipper{next: [
    %Rock{rocks: [{0,0}, {1,0}, {2,0}, {3,0}], name: "minus"},
    %Rock{rocks: [{1,0}, {0,1}, {1,1}, {2,1}, {1,2}], name: "plus"},
    %Rock{rocks: [{0,0}, {1,0}, {2,0}, {2,1}, {2,2}], name: "inverse-L"},
    %Rock{rocks: [{0,0}, {0,1}, {0,2}, {0,3}], name: "pipe"},
    %Rock{rocks: [{0,0}, {1,0}, {0,1}, {1,1}], name: "square"}
  ]}

  @left {-1, 0}
  @right {1, 0}
  @down {0, -1}

  @left_edge 0
  @right_edge 6
  def solve(input) do
    gas_jets = read_gas_jets(input)
    IO.puts("Part 1:")
    IO.puts(part1(gas_jets))
    IO.puts("Part 2:")
    IO.puts(part2(gas_jets))
  end

  def part1(gas_jets_iteration) do
    [state_after_2022] = run_simulation(gas_jets_iteration)
    |> Stream.drop_while(fn state -> state.rocks_done < 2022 end)
    |> Enum.take(1)
    #show_state(state_after_2022)
    state_after_2022.highest + 1
  end

  def part2(gas_jets_iteration) do
    [state0, state1, state2] = run_simulation(gas_jets_iteration)
    |> Stream.take_every(Enum.count(gas_jets_iteration))
    |> Enum.take(3)
    cycle_size = state2.rocks_done - state1.rocks_done
    increase_by_cycle = state2.highest - state1.highest
    calculable = 1000000000000 - state0.rocks_done
    cycles = div(calculable, cycle_size)
    left_over = rem(calculable, cycle_size)
    [final_state] = run_simulation(gas_jets_iteration)
    |> Stream.drop_while(fn state -> state.rocks_done < state0.rocks_done + left_over end)
    |> Enum.take(1)
    1 + state0.highest + cycles * increase_by_cycle + (final_state.highest - state0.highest)
  end

  def run_simulation(gas_jets_iteration) do
    gas_jets = %Zipper{next: gas_jets_iteration}
    start_state = %SimState{jets: gas_jets, rocks: @rocks, position: {2, 3}}
    Stream.iterate(start_state, &step/1)
  end

  def step(
    %SimState{
      jets: %Zipper{next: [jet | _]} = jets,
      rocks: %Zipper{next: [rock | _]} = rocks} = state
  ) do
    pos_jet = do_move(rock, state.position, jet, state.filled)
    pos_fall = do_move(rock, pos_jet, @down, state.filled)
    new_state = %{state | jets: Zipper.advance(jets)}
    if pos_jet != pos_fall do
      %{new_state | position: pos_fall}
    else
      rock_chunks = translate_rocks(rock, pos_fall)
      new_filled = rock_chunks |> Enum.reduce(state.filled, &MapSet.put(&2, &1))
      new_highest = max(state.highest, rock_chunks |> Enum.map(&elem(&1, 1)) |> Enum.max())
      new_position = add({0, new_highest}, {2, 4})
      %{new_state | rocks: Zipper.advance(rocks), filled: new_filled, position: new_position,
          highest: new_highest, rocks_done: state.rocks_done + 1}
    end
  end

  defp do_move(rock, position, move, filled) do
    new_position = add(position, move)
    moved = rock |> translate_rocks(new_position)
    collided = Enum.any?(moved, fn {x, y} = pos ->
      x < @left_edge || @right_edge < x || y < 0 || MapSet.member?(filled, pos) end)
    if collided, do: position, else: new_position
  end

  def add({x0, y0}, {x1, y1}), do: {x0 + x1, y0 + y1}

  def translate_rocks(%Rock{rocks: rocks}, move) do
    rocks |> Enum.map(&add(&1, move))
  end

  def read_gas_jets(input) do
    String.to_charlist(input) |> Enum.map(&if &1 == ?<, do: @left, else: @right)
  end

  def show_state(%SimState{rocks: %Zipper{next: [rock | _]}} = state, limit \\ -1) do
    rock_chunks = translate_rocks(rock, state.position)
    highest_chunk = rock_chunks |> Enum.map(&elem(&1, 1)) |> Enum.max()
    start_at = if limit < 0, do: 0, else: highest_chunk - limit
    lines = for line <- start_at..max(highest_chunk, state.highest) do
      pixels = for x <- @left_edge..@right_edge do
        pos = {x, line}
        if MapSet.member?(state.filled, pos), do: ?#, else:
        if Enum.member?(rock_chunks, pos), do: ?@, else:
        ?.
      end
      "|#{pixels}|"
    end
    IO.puts("After #{state.rocks_done} (highest: #{state.highest})")
    ((if limit < 0, do: ["+-------+"], else: ["~~~~~~~~~"]) ++ lines)
    |> Enum.reverse()
    |> Enum.join("\n")
    |> IO.puts()
  end
end
