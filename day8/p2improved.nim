import os, math
import std/[strutils, sequtils]

type
  Segment = enum sA, sB, sC, sD, sE, sF, sG
  Digit = set[Segment]

func toDigit(chars: string): Digit =
  chars.mapIt(Segment(ord(it) - ord('a'))).foldl(a + Digit({b}), Digit({}))

proc main() =
  let fileName = paramStr(1)

  # The main idea here is to use process of elimination to find each number
  # uniquely. To do this, we can use sets to eliminate or isolate numbers
  # that we don't know. Inspired by:
  # https://github.com/ZoomRmc/aoc2021_nim/blob/main/src/aoc08.nim

  var sum = 0

  const maxSetSize = 2^(Segment.high.int + 1)

  for line in fileName.lines:
    let
      lineSplit = line.split(" | ")
    var
      digitMap: array[maxSetSize, int]
      allDigits = lineSplit[0].strip().splitWhitespace().map(toDigit)
      displayDigits = lineSplit[1].strip().splitWhitespace().map(toDigit)

    #                0,  1, 2, 3, 4,  5,  6, 7
    let lenToNum = [-1, -1, 1, 7, 4, -1, -1, 8]

    var
      decoded: array[10, Digit]
      group235: seq[Digit]
      group069: seq[Digit]

    for digit in allDigits:
      case len(digit):
      of 2..4, 7:
        decoded[lenToNum[len(digit)]] = digit
      of 5:
        group235.add(digit)
      of 6:
        group069.add(digit)
      else: discard

    for digit in group235:
      if (digit - decoded[4]).len == 3:
        decoded[2] = digit
      elif (digit - decoded[1]).len == 3:
        decoded[3] = digit
      else:
        decoded[5] = digit

    for digit in group069:
      if (digit - decoded[4]).len == 2:
        decoded[9] = digit
      elif (digit - decoded[7]).len == 4:
        decoded[6] = digit
      else:
        decoded[0] = digit

    for i, digit in decoded:
      digitMap[cast[int](digit)] = i

    var i = 0
    # wish I could access the index in mapIt :/
    let mapped = displayDigits.mapIt:
      let power = 10^(3-i)
      i += 1
      digitMap[cast[int](it)] * power

    sum += mapped.foldl(a+b)

  echo "Sum of digits: ", sum

main()
