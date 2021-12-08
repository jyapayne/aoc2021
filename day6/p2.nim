import os, sequtils, tables
import std/strutils

const SIM_DAYS = 256

proc main() =
  let fileName = paramStr(1)

  let f = fileName.open(fmRead)

  # Lol, I was so tired. Didn't even realize I recreated
  # an array in table form
  let lanternFishSim = {
    0: 0,
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
    7: 0,
    8: 0
  }.newTable

  for num in f.readLine().split(",").mapIt(it.parseInt):
    lanternFishSim[num] += 1

  f.close()

  for i in 0 ..< SIM_DAYS:

    let
      temp0 = lanternFishSim[0]
      temp1 = lanternFishSim[1]
      temp2 = lanternFishSim[2]
      temp3 = lanternFishSim[3]
      temp4 = lanternFishSim[4]
      temp5 = lanternFishSim[5]
      temp6 = lanternFishSim[6]
      temp7 = lanternFishSim[7]
      temp8 = lanternFishSim[8]

    # move the fish down and add 7 and 0 together
    # to simulate reproduction
    lanternFishSim[8] = temp0
    lanternFishSim[7] = temp8
    lanternFishSim[6] = temp7 + temp0
    lanternFishSim[5] = temp6
    lanternFishSim[4] = temp5
    lanternFishSim[3] = temp4
    lanternFishSim[2] = temp3
    lanternFishSim[1] = temp2
    lanternFishSim[0] = temp1

  echo "NumFish: ", toSeq(lanternFishSim.values()).foldl(a + b)

main()
