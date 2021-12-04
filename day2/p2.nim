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
    aim = 0

  for val in fileName.lines:
    let
      commandAndUnits = val.split(" ")
      command = parseEnum[Command](commandAndUnits[0])
      units = commandAndUnits[1].parseInt

    case command
    of Forward:
      horizontal += units
      depth += aim * units
    of Up:
      aim -= units
    of Down:
      aim += units

  echo "Horizontal x Depth: ", horizontal * depth

main()
