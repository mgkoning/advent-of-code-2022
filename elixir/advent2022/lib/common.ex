defmodule Advent2022.Common do
  def take_until_including([], _), do: []
  def take_until_including([x | xs], fun) do
    [x | (if fun.(x), do: [], else: take_until_including(xs, fun))]
  end
end
