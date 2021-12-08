import os
import std/strutils

type
  Segment = enum
    One = 2
    Seven = 3
    Four = 4
    Eight = 7

proc main() =
  let fileName = paramStr(1)

  # store count for 1, 4, 7, 8
  var count = 0

  for line in fileName.lines:
    let display = line.split(" | ")[1].strip()
    let digits = display.splitWhitespace()

    for digit in digits:
      case len(digit).Segment:
      of One, Four, Seven, Eight:
        count += 1

  echo "Count of 1, 4, 7, 8: ", count

main()
