import os, math, sets
import std/[strutils, sequtils, strscans]

proc calculateInitialVelocity(endSum: int): float =
  # This is the inverse of S = N(N+1)/2
  # which is N = root(2*S + 1/4) - 1/2
  math.sqrt(2*endSum.float + 1/4) - 1/2

proc sum1toN(N: int): float =
  N*(N+1)/2

proc main() =
  let fileName = paramStr(1)

  let (_, lowerX, upperX, lowerY, _) = fileName.readFile().strip().scanTuple("target area: x=$i..$i, y=$i..$i")


  # in order to maximize y, we must maximize X first
  # we do this by calculating the exact value of the
  # initial X velocity that will get us within lowerX..upperX
  var xMaxSteps: HashSet[(int, int)]

  for x in lowerX .. upperX:
    let initialXVel = calculateInitialVelocity(x)
    # it's an integer with no floating point value
    if (initialXVel - int(initialXVel).float) == 0:
      xMaxSteps.incl((initialXVel.int, int(x.float - initialXVel)))


  # This part involves a bit of math, but hear me out. In order to get the
  # max height, we must get the max initial Y velocity because they are directly
  # proportional to eachother.
  #
  #            --- at the top, YVel = 0, numSteps = N(N+1)/2 because of the sum law
  #
  #      /             \
  #     /               \
  #    /                 \
  #   /                   \
  #  / YVel = initYVel     \ YVel = -initYVel
  #--- y = 0 --------------- y = 0 -----------------
  #
  #                           \ on the next step, y = -initVel - 1,
  #                             and that means if we can still get within
  #                             lowerY..upperY, we have found the max initYVel
  #
  # So this means that the max initYVel is
  #
  # lowerY = -initVel - 1, then solving for initVel, we get
  # initVel = -lowerY - 1, for y < 0 and if maxStepsX <= numStepsY, since after maxStepsX
  # x will never change again since it's velocity will be 0
  #
  # maxStepsY = initYVel * 2 + 2
  #
  # one +1 for the zero step at the top of the curve, and one for the last step
  # from y = 0 to y = -initVel - 1


  let maxInitYVel = -lowerY - 1
  let maxStepsY = maxInitYVel*2 + 2

  let allXStepsLowerEqual = xMaxSteps.allIt(it[1] <= maxStepsY)

  if allXStepsLowerEqual:
    echo "Max height: ", maxInitYVel.sum1toN().int
  else:
    echo "Failure"

main()
