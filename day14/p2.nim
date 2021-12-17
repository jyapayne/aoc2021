import os, tables
import std/[strutils, sequtils, algorithm, lists]

const STEP_COUNT = 40

type
  Pair = (char, char)

proc `$`(pair: Pair): string =
  '"' & pair[0] & pair[1] & '"'

proc main() =
  let file = paramStr(1).open(fmRead)

  let steps = if paramCount() > 1: paramStr(2).parseInt else: STEP_COUNT

  var
    polyTemplate = file.readLine()
    replaceMap = initTable[Pair, char]()
    countTable = initCountTable[char]()
    pairTable = initCountTable[Pair]()

  for i in 1 ..< polyTemplate.len:
    countTable.inc polyTemplate[i-1]
    pairTable.inc((polyTemplate[i-1], polyTemplate[i]))

  countTable.inc polyTemplate[^1]

  # skip blank line
  discard file.readLine()

  for line in file.lines:
    let split = line.split(" -> ")
    replaceMap[(split[0][0], split[0][1])] = split[1][0]

  for step in 0 ..< steps:
    var newPairTable = initCountTable[Pair]()

    for pair, num in pairTable:
      if pair in replaceMap:
        let ch = replaceMap[pair]
        newPairTable.inc((pair[0], ch), num)
        newPairTable.inc((ch, pair[1]), num)
        countTable.inc(ch, num)
      else:
        newPairTable.inc(pair)

    pairTable = newPairTable

  let counts = countTable.pairs.toSeq.sorted(proc (a, b: (char, int)): int = cmp(a[1], b[1]))

  echo "Difference: ", counts[^1][1] - counts[0][1]

  file.close()

main()
