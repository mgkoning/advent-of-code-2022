package advent2022

import kotlin.test.Test
import kotlin.test.assertNotNull
import kotlin.test.assertEquals

class Day01Test {
  val sampleInput = """
    1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000""".trimIndent()

  @Test fun topBurden() {
    var burdens = Day01.readAndSortBurdens(sampleInput)
    assertEquals(24000, burdens.take(1).sum())
    assertEquals(45000, burdens.take(3).sum())
  }
}
