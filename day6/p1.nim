import os, sequtils
import std/strutils

const SIM_DAYS = 80

proc main() =
  let fileName = paramStr(1)

  let f = fileName.open(fmRead)

  var lanternFishSim = f.readLine().split(",").mapIt(it.parseInt.uint8)

  f.close()

  for i in 0 ..< SIM_DAYS:
    var newFish: seq[uint8]

    for fish in lanternFishSim.mitems:
      if fish == 0:
        newFish.add(8.uint8)
        fish = 6
      else:
        fish -= 1

    lanternFishSim.add(newFish)

  echo "NumFish: ", len(lanternFishSim)



main()
