defmodule Advent2022.Day02 do
  def solve(input) do
    rounds = String.split(input, ~r/\n/)
    |> Enum.map(&read_round/1)

    IO.puts("Part 1:")
    score_part1 = rounds
    |> play_game(&translate_part1/1)
    IO.puts(score_part1)

    IO.puts("Part 2:")
    score_part2 = rounds
    |> play_game(&translate_part2/1)
    IO.puts(score_part2)
  end

  defp play_game(all_rounds, translate_fn) do
    all_rounds
    |> Enum.map(translate_fn)
    |> Enum.map(&play_round/1)
    |> Enum.sum()
  end

  defp read_round(line) do
    <<p1::utf8, _::utf8, p2::utf8>> = line
    {p1, p2}
  end

  @code_book_p1 %{?A => 1, ?B => 2, ?C => 3}
  @code_book_p2 %{?X => 1, ?Y => 2, ?Z => 3}
  defp translate_part1({p1, p2}) do
    {Map.fetch!(@code_book_p1, p1), Map.fetch!(@code_book_p2, p2)}
  end

  defp translate_part2({p1, p2}) do
    p1_choice = Map.fetch!(@code_book_p1, p1)
    {p1_choice, choose_result({p1_choice, p2})}
  end

  defp choose_result({1, ?X}), do: 3
  defp choose_result({2, ?X}), do: 1
  defp choose_result({3, ?X}), do: 2
  defp choose_result({p1, ?Y}), do: p1
  defp choose_result({1, ?Z}), do: 2
  defp choose_result({2, ?Z}), do: 3
  defp choose_result({3, ?Z}), do: 1

  defp play_round(hands) do
    {_, p2} = hands
    p2 + round_score(hands)
  end

  defp round_score({p1, p2}) when p1 == p2, do: 3
  defp round_score({1, 2}), do: 6
  defp round_score({1, 3}), do: 0
  defp round_score({2, 1}), do: 0
  defp round_score({2, 3}), do: 6
  defp round_score({3, 1}), do: 6
  defp round_score({3, 2}), do: 0
end
