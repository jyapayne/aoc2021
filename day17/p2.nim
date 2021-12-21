import os
import std/[strutils, strscans]

type
  Velocity = tuple[x, y: int]

proc main() =
  let fileName = paramStr(1)

  let (_, lowerX, upperX, lowerY, upperY) = fileName.readFile().strip().scanTuple("target area: x=$i..$i, y=$i..$i")

  # The maximum value initXVel can be is upperX, since that will take only one step
  # and will be within lowerX..upperX
  # The min value initXVel can be is zero, since negative values will only move
  # backwards
  #
  # The maximum value initYVel can be was found in p1, so we can just use it here
  # The min value it can be is lowerY, if lowerX <= initXVel <= upperX

  let maxInitYVel = -lowerY - 1

  var allPossibleVels: seq[Velocity]

  for xVel in 0 .. upperX:
    block YBlock:
      for yVel in countDown(maxInitYVel, lowerY):
        var initVels = (x: xVel, y: yVel)
        var currentPoint = (x: 0, y: 0)

        var vels = initVels

        while currentPoint.x < upperX and currentPoint.y > lowerY:
          if vels.x == 0 and currentPoint.x < lowerX:
            # Can't ever make it
            break YBlock
          if vels.y + currentPoint.y < lowerY:
            # blow past the lowerY val
            break

          currentPoint.x += vels.x
          currentPoint.y += vels.y

          if currentPoint.x in lowerX..upperX and currentPoint.y in lowerY..upperY:
            allPossibleVels.add(initVels)
            break

          if vels.x > 0:
            vels.x.dec
          vels.y.dec


  echo "Max pairs: ", allPossibleVels.len

main()
