import os
import std/[strutils, sequtils, algorithm]


proc main() =
  # initial idea is to sort input and 
  let fileName = paramStr(1)
  let f = open(fileName, fmRead)

  var crabs = f.readLine().split(",").mapIt(it.strip.parseInt)

  f.close()

  crabs.sort(cmp)

  let median = crabs[(crabs.len/2).int]
  echo median

  let fuel = crabs.mapIt(abs(it-median)).foldl(a+b)

  echo "Min fuel: ", fuel

main()
