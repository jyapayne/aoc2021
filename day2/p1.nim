import os
import std/strutils

type
  Command = enum
    Forward = "forward",
    Down = "down",
    Up = "up"

proc main() =
  let fileName = paramStr(1)

  var
    horizontal = 0
    depth = 0

  for val in fileName.lines:
    let
      commandAndUnits = val.split(" ")
      command = parseEnum[Command](commandAndUnits[0])
      units = commandAndUnits[1].parseInt

    case command
    of Forward:
      horizontal += units
    of Up:
      depth -= units
    of Down:
      depth += units

  echo "Horizontal x Depth: ", horizontal * depth

main()
