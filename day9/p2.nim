import os, sets
import std/[sequtils, algorithm]

template parseLine(line: string): seq[uint8] =
  line.mapIt((ord(it) - ord('0')).uint8)

proc checkMin(caveHeights: seq[seq[uint8]], row, col: int): bool {.inline.} =
  let checks = [
    (row - 1, col),
    (row, col + 1),
    (row, col - 1),
    (row + 1, col)
  ]
  for (checkRow, checkCol) in checks:
    if checkRow < 0 or checkCol < 0 or checkRow >= len(caveHeights) or checkCol >= len(caveHeights[checkRow]):
      continue
    if caveHeights[checkRow][checkCol] <= caveHeights[row][col]:
      return false

  return true

proc getBasinSize(caveHeights: seq[seq[uint8]], row, col: int): int {.inline.} =
  var stack = @[(row, col)]
  var visited: HashSet[(int, int)]

  while stack.len > 0:
    let item = stack.pop

    if item in visited:
      continue
    visited.incl(item)

    let checks = [
      (item[0] - 1, item[1]),
      (item[0], item[1] + 1),
      (item[0], item[1] - 1),
      (item[0] + 1, item[1])
    ]

    result += 1

    for (checkRow, checkCol) in checks:
      if (checkRow < 0 or checkCol < 0 or
          checkRow >= len(caveHeights) or
          checkCol >= len(caveHeights[checkRow])):
        continue

      let
        curCell = caveHeights[item[0]][item[1]]
        checkCell = caveHeights[checkRow][checkCol]

      if checkCell > curCell and checkCell < 9:
        stack.add((checkRow, checkCol))

proc main() =
  let
    fileName = paramStr(1)

  var caveHeights: seq[seq[uint8]]

  for line in fileName.lines:
    caveHeights.add(parseLine(line))

  var sizes: seq[int]

  for i, rowVals in caveHeights:
    for j, num in rowVals:
      if caveHeights.checkMin(i, j):
        sizes.add caveHeights.getBasinSize(i, j)

  echo "Product 3 largest: ", sorted(sizes, Descending)[0..2].foldl(a*b)

main()
