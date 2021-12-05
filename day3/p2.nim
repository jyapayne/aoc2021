import os
import std/[strutils, enumerate, sets, sequtils]

proc getMostCommon(indices: var HashSet[int], values: var seq[string]): string =
  var counts = newSeq[int](len(values[0]))

  for index in indices:
    let binary = values[index]
    for (i, binVal) in enumerate(binary):
      counts[i] += (if binVal == '1': 1 else: -1)

  result = newString(counts.len)

  for (i, val) in enumerate(counts):
    if val > 0: # one is most common
      result[i] = '1'
    elif val < 0: # zero is most common
      result[i] = '0'
    else: # zero and one are the same commonality
      result[i] = '1'

proc getLeastCommon(indices: var HashSet[int], values: var seq[string]): string =
  var counts = newSeq[int](len(values[0]))

  for index in indices:
    let binary = values[index]
    for (i, binVal) in enumerate(binary):
      counts[i] += (if binVal == '1': 1 else: -1)

  result = newString(counts.len)

  for (i, val) in enumerate(counts):
    if val > 0: # one is most common
      result[i] = '0'
    elif val < 0: # zero is most common
      result[i] = '1'
    else: # zero and one are the same commonality
      result[i] = '0'

proc main() =
  let fileName = paramStr(1)

  # if we have a one, increase the counter
  # otherwise for zero, decrease the counter for each bit
  # this will give a positive number for 1 being the most
  # common, and negative if 0 is the most common

  var binarySeq = newSeq[string]()

  for binary in fileName.lines:
    binarySeq.add(binary)

  var o2Indices = toHashSet(toSeq(0..<binarySeq.len))
  var co2Indices = toHashSet(toSeq(0..<binarySeq.len))

  var pos = 0
  while o2Indices.len > 1:
    var mostCommon = o2Indices.getMostCommon(binarySeq)
    if pos >= mostCommon.len:
      break
    let mc = mostCommon[pos]
    var o2Copy = o2Indices
    for index in o2Copy:
      let binVal = binarySeq[index][pos]
      if binVal != mc and o2Indices.len > 1:
        o2Indices.excl(index)

    pos += 1

  pos = 0
  while co2Indices.len > 1:
    var leastCommon = co2Indices.getLeastCommon(binarySeq)
    if pos >= leastCommon.len:
      break
    let lc = leastCommon[pos]
    var co2Copy = co2Indices
    for index in co2Copy:
      let binVal = binarySeq[index][pos]
      if binVal != lc and co2Indices.len > 1:
        co2Indices.excl(index)

    pos += 1

  let oxygen = binarySeq[o2Indices.toSeq[0]]
  let co2 = binarySeq[co2Indices.toSeq[0]]

  let lifeSupport = oxygen.parseBinInt * co2.parseBinInt
  echo "Life support rating: ", lifeSupport


main()
