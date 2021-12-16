import os, sets
import std/[strutils, sequtils]

type
  Dot = (uint16, uint16)

proc main() =
  let fileName = paramStr(1)

  var dots = HashSet[Dot]()

  for line in fileName.lines:
    if line.strip() == "":
      continue

    if not line.startsWith("fold"):
      let split = line.strip.split(",")
      dots.incl (split[0].parseInt.uint16, split[1].parseInt.uint16)
    else:
      var fold: (int, int) = (-1, -1)

      if line.startsWith("fold along x="):
        fold[0] = line.replace("fold along x=", "").parseInt
      else:
        fold[1] = line.replace("fold along y=", "").parseInt

      for dot in dots.deepCopy:
        var newDot: Dot = dot
        if fold[0] != -1 and dot[0] > fold[0].uint16:
          newDot[0] = 2*fold[0].uint16 - dot[0]
          dots.excl dot
        if fold[1] != -1 and dot[1] > fold[1].uint16:
          newDot[1] = 2*fold[1].uint16 - dot[1]
          dots.excl dot

        dots.incl newDot

      echo "Number of dots after one fold: ", dots.len
      return


main()
