import std/[strutils, sequtils, tables, os, strformat, sets]

type
  CaveKind = enum
    ckStart
    ckEnd
    ckSmall
    ckLarge

  CaveNode = ref object
    name: string
    neighbors: seq[CaveNode]
    kind: CaveKind

proc `$`(cave: CaveNode): string =
  fmt"CaveNode(name: {cave.name.repr}, kind: {cave.kind}, neighbors: {cave.neighbors.mapIt(it.name)})"

template makeCave(caveName: string): CaveNode =
  let caveKind = if caveName[0] >= 'A' and caveName[0] <= 'Z': ckLarge else: ckSmall
  CaveNode(name: caveName, kind: caveKind)

proc countPaths(visitCave, targetCave: CaveNode, visited: var HashSet[string], canTwice: bool): int =
  if visitCave.name == targetCave.name:
    return 1
  elif visitCave.kind == ckSmall:
    visited.incl visitCave.name

  for cave in visitCave.neighbors:
    if cave.name notin visited:
      result += countPaths(cave, targetCave, visited, canTwice)
      visited.excl cave.name
    elif cave.kind == ckSmall and canTwice:
      result += countPaths(cave, targetCave, visited, false)


proc main() =
  let
    fileName = paramStr(1)
    startCave = CaveNode(name: "start", kind: ckStart)
    endCave = CaveNode(name: "end", kind: ckEnd)

  var caveMap = {"start": startCave, "end": endCave}.newTable

  for line in fileName.lines:
    let
      split = line.strip().split("-")
      left = split[0]
      right = split[1]

    if left notin caveMap:
      caveMap[left] = makeCave(left)
    if right notin caveMap:
      caveMap[right] = makeCave(right)

    if right != "start" and left != "end":
      caveMap[left].neighbors.add(caveMap[right])
    if right != "end" and left != "start":
      caveMap[right].neighbors.add(caveMap[left])

  var visited = HashSet[string]()

  echo "Paths: ", countPaths(startCave, endCave, visited, true)

main()
