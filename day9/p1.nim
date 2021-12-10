import os
import std/[sequtils]

template parseLine(line: string): seq[uint8] =
  line.mapIt((ord(it) - ord('0')).uint8)

proc checkMin(window: array[3, seq[uint8]], row, col: int): bool {.inline.} =
  let checks = [
    (row - 1, col),
    (row, col + 1),
    (row, col - 1),
    (row + 1, col)
  ]

  for (checkRow, checkCol) in checks:
    if checkRow < 0 or checkCol < 0 or checkRow >= len(window) or checkCol >= len(window[checkRow]):
      continue
    if window[checkRow][checkCol] <= window[row][col]:
      return false

  return true

proc main() =
  let
    fileName = paramStr(1)
    f = open(fileName, fmRead)

  # use a sliding window for efficiency. Only ever have
  # 3 lines of the file in memory
  var window: array[3, seq[uint8]]

  window[1] = parseLine(f.readLine())
  window[2] = parseLine(f.readLine())

  var minSum = 0
  var i = 1

  while window[1].len > 0:
    for j, num in window[i]:
      if window.checkMin(i, j):
        minSum += num.int + 1

    # swap lines
    window[0] = window[1]
    window[1] = window[2]
    if not f.endOfFile:
      window[2] = parseLine(f.readLine())
    else:
      window[2] = @[]

  f.close()

  echo "Min sum: ", minSum

main()
