defmodule Advent2022.Zipper do
  alias Advent2022.Zipper

  @enforce_keys [:next]
  defstruct next: [], prev: [], show_cycle?: false

  def current(%Zipper{next: [n | _]}), do: n
  def pop(%Zipper{next: [n | ns]} = zipper), do: {n, %{zipper | next: ns}}
  def push(%Zipper{next: ns} = zipper, n), do: %{zipper | next: [n | ns]}

  def advance(%Zipper{next: [], prev: ps, show_cycle?: show_cycle?} = zipper) do
    if show_cycle?, do: IO.puts("cycling")
    [n | ns] = Enum.reverse(ps)
    %{zipper | next: ns, prev: [n]}
  end
  def advance(%Zipper{next: [n], prev: ps, show_cycle?: show_cycle?} = zipper) do
    if show_cycle?, do: IO.puts("cycling")
    %{zipper | next: Enum.reverse(ps), prev: [n]}
  end
  def advance(%Zipper{next: [n | ns], prev: ps} = zipper) do
    %{zipper | next: ns, prev: [n | ps]}
  end

  def back(%Zipper{next: ns, prev: []} = zipper) do
    [p | ps] = Enum.reverse(ns)
    %{zipper | next: [p], prev: ps}
  end
  def back(%Zipper{next: ns, prev: [p | ps]} = zipper) do
    %{zipper | next: [p | ns], prev: ps}
  end

  def find(_, _, max_moves) when max_moves < 0, do: :error
  def find(%Zipper{next: [n | _]} = zipper, match?, max_moves) do
    if match?.(n), do: zipper, else: find(advance(zipper), match?, max_moves-1)
  end

  def move(zipper, 0), do: zipper
  def move(zipper, n) when n > 0 do
    move(advance(zipper), n-1)
  end
  def move(zipper, n) when n < 0 do
    move(back(zipper), n+1)
  end

  def to_list(%Zipper{next: ns, prev: ps}), do: ns ++ Enum.reverse(ps)
end
