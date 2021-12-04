import os
import std/strutils

proc main() =
  let fileName = paramStr(1)

  var increased = 0
  var lastVal = -1

  for val in fileName.lines:
    let curVal = val.parseInt

    if lastVal != -1 and lastVal < curVal:
      increased += 1

    lastVal = curVal

  echo increased, " increases"



main()
