import os
import std/[strutils, sequtils]

proc main() =
  # the idea here is to find a position from all possible
  # crab positions at which the sum of all fuel consumption
  # is the minimum. So we find the total fuel consumption for
  # all possible crab positions, then pick the minimum one
  let
    fileName = paramStr(1)
    f = open(fileName, fmRead)

  var crabs = f.readLine().split(",").mapIt(it.strip.parseInt)

  f.close()

  let
    maxVal = max(crabs)

  var
    minSum = int.high
    minPos = -1

  for pos in 0 .. maxVal:
    var sum = 0
    for crab in crabs:
      let N = abs(crab - pos)
      # sum of 1 + 2 + 3 + ... N is N(N+1)/2
      sum += int((N*(N+1))/2)
    if sum < minSum:
      minSum = sum
      minPos = pos

  # sum of 1 + 2 + 3 + ... N is N(N+1)/2
  let fuel = crabs.mapIt(int(abs(it-minPos)*(abs(it-minPos)+1)/2)).foldl(a+b)
  echo "Min fuel: ", fuel

main()
