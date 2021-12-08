import os, sets, math
import std/[strutils, sequtils]

type
  Digit = enum
    One = 2
    Seven = 3
    Four = 4
    TwoThreeFive = 5
    ZeroSixNine = 6
    Eight = 7

proc main() =
  let fileName = paramStr(1)

  # The main idea here is to use process of elimination to find each number
  # uniquely. To do this, we can use hashsets to eliminate or isolate numbers
  # that we don't know.

  var sum = 0

  for line in fileName.lines:
    let
      lineSplit = line.split(" | ")
      allDigits = lineSplit[0].strip().splitWhitespace()
      displayDigits = lineSplit[1].strip().splitWhitespace()

    var
      oneDigit: HashSet[char]
      fourDigit: HashSet[char]
      sevenDigit: HashSet[char]
      eightDigit: HashSet[char]
      twoThreeFiveDigits = newSeqOfCap[HashSet[char]](3)
      zeroSixNineDigits = newSeqOfCap[HashSet[char]](3)

    for digit in allDigits:
      case len(digit).Digit:
      of One:
        oneDigit.incl toHashSet(digit)
      of Four:
        fourDigit.incl toHashSet(digit)
      of Seven:
        sevenDigit.incl toHashSet(digit)
      of Eight:
        eightDigit.incl toHashSet(digit)
      of TwoThreeFive:
        twoThreeFiveDigits.add toHashSet(digit)
      of ZeroSixNine:
        zeroSixNineDigits.add toHashSet(digit)

    # this section is pretty inefficient, but reduces code complexity. Since
    # the seqs are only length 3, iterating over them multiple times is fine.
    #
    # we isolate the numbers based on process of elimination to uniquely identify
    # each number
    let
      twoDigit = twoThreeFiveDigits.filterIt((it - fourDigit).len == 3)[0]
      threeDigit = twoThreeFiveDigits.filterIt((it - oneDigit).len == 3)[0]
      fiveDigit = twoThreeFiveDigits.filterIt((it - twoDigit).len == 2)[0]

      lowerLeftSegment = twoDigit - threeDigit
      upperLeftSegment = fourDigit - threeDigit
      middleSegment = (fourDigit - oneDigit) - upperLeftSegment
      upperRightSegment = (twoDigit - fiveDigit) - lowerLeftSegment

      zeroDigit = zeroSixNineDigits.filterIt((it - middleSegment).len == 6)[0]
      sixDigit = zeroSixNineDigits.filterIt((it - upperRightSegment).len == 6)[0]
      nineDigit = zeroSixNineDigits.filterIt((it - lowerLeftSegment).len == 6)[0]

    var localSum = 0

    for i in 0 ..< displayDigits.len:
      let displayDigit = toHashSet(displayDigits[i])
      var digit: uint8

      # there's probably a better way to do this
      if displayDigit == zeroDigit:
        digit = 0
      if displayDigit == oneDigit:
        digit = 1
      elif displayDigit == twoDigit:
        digit = 2
      elif displayDigit == threeDigit:
        digit = 3
      elif displayDigit == fourDigit:
        digit = 4
      elif displayDigit == fiveDigit:
        digit = 5
      elif displayDigit == sixDigit:
        digit = 6
      elif displayDigit == sevenDigit:
        digit = 7
      elif displayDigit == eightDigit:
        digit = 8
      elif displayDigit == nineDigit:
        digit = 9

      localSum += (digit.float * math.pow(10.0, (3 - i).float)).int

    sum += localSum

  echo "Sum of digits: ", sum

main()
