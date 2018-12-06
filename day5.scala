#!/usr/bin/env scala

object Day5 {
 
  def react(input: String): String = {
    input.grouped(2).filter((pair: String) =>
      pair.length == 1 ||
      pair(0) == pair(1) ||
      pair(0).toLower != pair(1).toLower
    ).mkString
  }

  def reactAll(input: String): Int = {
    var a = react(input)
    var b = a.head + react(a.tail)
    if (b!= input) reactAll(b) else b.length
  }

  def main(args: Array[String]): Unit = {
    val filename = "input/day5.txt"
    val input = scala.io.Source.fromFile(filename).mkString.trim

    println(reactAll(input))

    val letters = input.toLowerCase.toSet
    val counts = letters.map((c : Char) =>
      reactAll(input.filterNot(Set(c, c.toUpper)))
    )

    println(counts.min)
  }
  
}
