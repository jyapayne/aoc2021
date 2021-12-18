import os, sugar
import std/[strutils, sequtils, sets, tables, heapqueue]

type
  Position = (int, int)

template `[]`(cavern: seq[string], pos: Position): int =
  let
    multiplierRow = pos[0] div cavern.len
    multiplierCol = pos[1] div cavern[0].len
    multiplier = multiplierRow + multiplierCol
    posRow = pos[0] mod cavern.len
    posCol = pos[1] mod cavern[0].len
    origNum = ord(cavern[posRow][posCol]) - ord('0')

    value = origNum + multiplier

  if value > 9:
    value - 9
  else:
    value


template neighbors(cavern: seq[string], pos: Position): seq[(Position, int)] =
  @[
    (pos[0], pos[1] - 1),
    (pos[0] - 1, pos[1]),
    (pos[0], pos[1] + 1),
    (pos[0] + 1, pos[1])
  ].filterIt(
    it[0] >= 0 and it[1] >= 0 and it[0] < cavern.len*5 and it[1] < cavern[0].len*5
  ).mapIt((it, cavern[it]))

template `<`(tup1, tup2: (Position, int)): bool =
  tup1[1] < tup2[1]

proc main() =
  let fileName = paramStr(1)

  let cavern = fileName.readFile().splitWhitespace()

  var
    visited = HashSet[Position]()
    currentNode: Position = (0, 0)
    endNode: Position = (cavern.len*5-1, cavern[0].len*5-1)

  # Use djikstra's algo with a heap queue
  var distanceMap = collect:
    for i in 0..<cavern.len*5:
      for j in 0..<cavern[0].len*5:
        {(i, j): int.high}

  distanceMap[currentNode] = 0

  var pq = initHeapQueue[(Position, int)]()
  pq.push((currentNode, 0))

  while pq.len > 0:
    # Only use the weight for the priority queue
    let (node, _) = pq.pop
    visited.incl node

    for (neighbor, weight) in cavern.neighbors(node):
      if neighbor notin visited:
        let
          oldCost = distanceMap[neighbor]
          newCost = distanceMap[node] + weight
        if newCost < oldCost:
          pq.push((neighbor, newCost))
          distanceMap[neighbor] = newCost

  echo distanceMap[endNode]

main()
