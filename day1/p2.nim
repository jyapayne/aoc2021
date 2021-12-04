import os
import sequtils
import std/strutils

proc main() =
  let fileName = paramStr(1)

  var increased = 0
  var lastVal = -1

  var window = [0, 0, 0]
  var windowPos = 0

  for val in fileName.lines:
    let intVal = val.parseInt
    var curVal = 0

    window[windowPos] = intVal

    if windowPos == (len(window) - 1):
      # add the values and store
      curVal = window.foldl(a + b)

      if lastVal != -1 and lastVal < curVal:
        increased += 1

      lastVal = curVal

      # move values up the window
      window[0] = window[1]
      window[1] = window[2]
      window[2] = intVal
    else:
      windowPos += 1

  echo increased, " increases"

main()
