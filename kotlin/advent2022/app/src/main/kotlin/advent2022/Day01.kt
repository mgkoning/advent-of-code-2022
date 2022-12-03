package advent2022

object Day01 {
  fun solve(input: String) {
    var burdens = readAndSortBurdens(input)
    println("Part 1:")
    println(burdens.take(1).sum())
    println("Part 2:")
    println(burdens.take(3).sum())
  }

  fun readAndSortBurdens(input: String): List<Int> =
    input.split("\n\n")
      .map(Day01::readElf)
      .sortedDescending()

  private fun readElf(elf: String): Int =
    elf.lines()
      .map { it.toInt() }
      .sum()
}