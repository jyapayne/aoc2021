import os, sequtils
import std/strutils

const SIM_DAYS = 256
const FISH_DAYS = 8

proc main() =
  let fileName = paramStr(1)

  let f = fileName.open(fmRead)

  var lanternFishSim: array[0..FISH_DAYS, int]

  # get all of the initial counts of fish
  for fishDay in f.readLine().split(",").mapIt(it.parseInt):
    lanternFishSim[fishDay] += 1

  f.close()


  for i in 0 ..< SIM_DAYS:

    let spawningFish = lanternFishSim[0]

    # decrease all fish by one
    for day in 0 .. FISH_DAYS-1:
      lanternFishSim[day] = lanternFishSim[day+1]

    # set the newly spawned fish
    lanternFishSim[FISH_DAYS] = spawningFish

    # 6 day left fish now only have the 7 day fish from
    # the last round. We need to add the spawning fish
    # to that count because they are refreshed at 6 days
    lanternFishSim[6] += spawningFish

  echo "NumFish: ", lanternFishSim.foldl(a + b)

main()
