defmodule Advent2022.Common do
  def take_until_including([], _), do: []
  def take_until_including([x | xs], fun) do
    [x | (if fun.(x), do: [], else: take_until_including(xs, fun))]
  end

  def insert_sorted([], v), do: [v]
  def insert_sorted([{_, length_head} = hd | rest], {_, length} = v) do
    if length < length_head do
      [v | [hd | rest]]
    else
      [hd | insert_sorted(rest, v)]
    end
  end
end
