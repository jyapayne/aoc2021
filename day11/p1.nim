import os, sets
import std/[strutils, sequtils]

const STEP_COUNT = 100

proc increaseEnergy(octopi: var seq[seq[uint8]], flashedOctopi: var HashSet[(int, int)], i, j: int) =

  var stack: seq[(int, int)] = @[(i, j)]

  while stack.len > 0:
    let (i, j) = stack.pop

    if i < 0 or i >= len(octopi) or
      j < 0 or j >= len(octopi[i]) or
      (i, j) in flashedOctopi:
      continue

    if octopi[i][j] < 9:
      octopi[i][j] += 1
    else:
      flashedOctopi.incl((i, j))
      octopi[i][j] = 0

      let energyIncreases = [
        (i-1, j-1), (i-1, j), (i-1, j+1),
        (i, j-1),             (i, j+1),
        (i+1, j-1), (i+1, j), (i+1, j+1),
      ]

      stack.add energyIncreases


proc main() =
  let fileName = paramStr(1)
  let numSteps = if paramCount() > 1:
      paramStr(2).parseInt
    else:
      STEP_COUNT

  var octopi: seq[seq[uint8]]

  for line in fileName.lines:
    octopi.add line.mapIt((ord(it) - ord('0')).uint8)

  var flashCount = 0
  for step in 0 ..< numSteps:
    var flashedOctopi: HashSet[(int, int)]

    for i in 0 ..< len(octopi):
      for j in 0 ..< len(octopi[0]):
        octopi.increaseEnergy(flashedOctopi, i, j)

    flashCount += flashedOctopi.len

  for octoLine in octopi:
    echo octoLine.join("")

  echo "Flashed: ", flashCount

main()
