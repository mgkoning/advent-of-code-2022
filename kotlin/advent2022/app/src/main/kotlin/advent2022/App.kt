package advent2022

import kotlin.io.path.*
import java.nio.charset.StandardCharsets
import java.nio.file.Paths

private val runMap = mapOf(1 to Day01::solve)

fun main(args: Array<String>) {
    when {
        args.isEmpty() -> println("Please supply a day to run")
        else -> {
            args[0].let { arg ->
                arg.toIntOrNull()
                ?.let { day -> runMap.get(day)
                    ?.invoke(getInputPath(day).readText(StandardCharsets.UTF_8))
                    ?: println("Day $day not supported") }
                ?: println("Day $arg is not valid")
            }
        }
    }
}

private fun getInputPath(day: Int) =
  Path("../../../input/day${day.toString().padStart(2, '0')}.txt")
