defmodule Advent2022.Day01.Test do
  import Advent2022.Day01
  use ExUnit.Case

  @sample_input "1000
2000
3000

4000

5000
6000

7000
8000
9000

10000"

  test "sample input" do
    burdens = @sample_input |> burdens_by_heaviest()
    assert sum_topN(burdens, 1) == 24000
    assert sum_topN(burdens, 3) == 45000
  end
end
