defmodule Advent2022.Common do
  def enumerated(enumerable, from \\ 0) do
    Stream.zip(Stream.iterate(from, &(&1 + 1)), enumerable)
  end

  def take_until_including([], _), do: []
  def take_until_including([x | xs], fun) do
    [x | (if fun.(x), do: [], else: take_until_including(xs, fun))]
  end
end
