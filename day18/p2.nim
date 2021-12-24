import os, math, strformat, sets, hashes
import std/[strutils, strscans]

type
  SnailFishKind = enum
    Single
    Pair

  SnailFishGroup = ref object
    nestLevel: int
    parent: SnailFishGroup
    case kind: SnailFishKind
    of Single:
      value: int
    of Pair:
      left: SnailFishGroup
      right: SnailFishGroup

# ------------------------- Helper procs -----------------------------------------------

proc `==`(s1, s2: SnailFishGroup): bool =
  cast[ByteAddress](s1) == cast[ByteAddress](s2)

proc hash(sf: SnailFishGroup): Hash =
  cast[ByteAddress](sf)

proc pairOrSingle(input: string, strVal: var string, start: int): int =
  result = 0
  if input[start] in {'0'..'9'}:
    strVal = $input[start]
    return 1

  var stack = @[input[start]]

  inc result
  strVal.add input[start]

  while start+result < input.len and stack.len > 0:
    if input[start+result] == '[':
      stack.add '['
    elif input[start+result] == ']':
      discard stack.pop

    strVal.add input[start+result]

    inc result

proc `$`(group: SnailFishGroup): string =
  case group.kind:
  of Single:
    $group.value
  of Pair:
    "[" & $group.left & ", " & $group.right & "]" #(" & $group.nestLevel & ")"

# --------------------------------------------------------------------------------------

proc incNestLevels(sf: SnailFishGroup) =
  case sf.kind:
  of Single:
    sf.nestLevel += 1
  of Pair:
    sf.nestLevel += 1
    sf.left.incNestLevels
    sf.right.incNestLevels

proc `+`(g1, g2: SnailFishGroup): SnailFishGroup =
  result = SnailFishGroup(kind: Pair)
  result.nestLevel = g1.nestLevel

  g1.incNestLevels
  g2.incNestLevels

  g1.parent = result
  g2.parent = result

  result.left = g1
  result.right = g2

proc explode(sf: var SnailFishGroup) =
  ## Went for an iterative approach with this one. Might be more clear to do
  ## it recursively, but I wanted to hurt my brain
  var visited = HashSet[SnailFishGroup]()

  var curr = sf.parent
  visited.incl sf

  # propogate left value left
  while not curr.isNil:
    visited.incl curr
    if curr.left notin visited:
      case curr.left.kind:
      of Single:
        curr.left.value += sf.left.value
      of Pair:
        # Confusingly, visually to the left is actually to the right in the tree
        var right = curr.left.right
        while right.kind != Single:
          right = right.right

        right.value += sf.left.value
      break
    curr = curr.parent

  curr = sf.parent
  visited.clear
  visited.incl sf

  # propogate right value right
  while not curr.isNil:
    visited.incl curr
    if curr.right notin visited:
      case curr.right.kind:
      of Single:
        curr.right.value += sf.right.value
      of Pair:
        # Confusingly, visually to the right is actually to the left in the tree
        var left = curr.right.left
        while left.kind != Single:
          left = left.left

        left.value += sf.right.value
      break
    curr = curr.parent

  sf = SnailFishGroup(kind: Single, nestLevel: sf.nestLevel, parent: sf.parent)


proc explodeAll(sf: var SnailFishGroup): bool =
  case sf.kind:
  of Single: discard
  of Pair:
    result = result or sf.left.explodeAll()
    result = result or sf.right.explodeAll()

    if sf.nestLevel >= 4:
      sf.explode()
      return true


proc splitAll(sf: var SnailFishGroup): bool =
  case sf.kind:
  of Single:
    if sf.value >= 10:
      let val = sf.value
      let nestLevel = sf.nestLevel
      sf = SnailFishGroup(kind: Pair, nestLevel: nestLevel, parent: sf.parent)
      let
        left = SnailFishGroup(kind: Single, value: val div 2, nestLevel: sf.nestLevel+1, parent: sf)
        right = SnailFishGroup(kind: Single, value: ceilDiv(val, 2), nestLevel: sf.nestLevel+1, parent: sf)

      sf.left = left
      sf.right = right
      return true
  of Pair:
    return sf.left.splitAll() or sf.right.splitAll()


proc parseSnailFishGroup(group: string, nestLevel=0): SnailFishGroup {.inline.} =
  if group.len == 1:
    return SnailFishGroup(kind: Single, nestLevel: nestLevel, value: group.parseInt)

  result = SnailFishGroup(kind: Pair)

  var left, right: string
  if group.scanf("[${pairOrSingle},${pairOrSingle}]", left, right):
    result.nestLevel = nestLevel

    result.left = parseSnailFishGroup(left, nestLevel+1)
    result.left.parent = result

    result.right = parseSnailFishGroup(right, nestLevel+1)
    result.right.parent = result
  else:
    raise newException(CatchableError, fmt"Error, could not parse group: {group}")

proc magnitude(sf: SnailFishGroup): int =
  case sf.kind:
  of Single:
    sf.value
  of Pair:
    sf.left.magnitude*3 + sf.right.magnitude*2

proc main() =
  let fileName = paramStr(1)

  var lines: seq[string]

  for line in fileName.lines:
    lines.add line

  var maxMagnitude = 0

  for i in 0 ..< lines.len:
    for j in 0 ..< lines.len:
      if i != j:
        var sum = lines[i].parseSnailFishGroup + lines[j].parseSnailFishGroup
        while true:
          let exploded = sum.explodeAll()
          if exploded: continue

          let split =  sum.splitAll()

          if not split and not exploded:
            break

        let magnitude = sum.magnitude
        if magnitude > maxMagnitude:
          maxMagnitude = magnitude

  echo "Max magnitude: ", maxMagnitude

main()
