import os
import std/[strutils, enumerate]

proc main() =
  let fileName = paramStr(1)

  # if we have a one, increase the counter
  # otherwise for zero, decrease the counter for each bit
  # this will give a positive number for 1 being the most
  # common, and negative if 0 is the most common

  var values = newSeq[int]()

  for binary in fileName.lines:
    if values.len == 0:
      values.setLen(binary.len)

    for (i, binVal) in enumerate(binary):
      values[i] += (if binVal == '1': 1 else: -1)


  var
    gamma = newString(values.len)
    epsilon = newString(values.len)

  for (i, val) in enumerate(values):
    if val > 0: # one is most common, so gamma is one, epsilon is zero
      gamma[i] = '1'
      epsilon[i] = '0'
    elif val < 0: # zero is most common, so gamma is zero, epsilon is one
      gamma[i] = '0'
      epsilon[i] = '1'


  let power = gamma.parseBinInt * epsilon.parseBinInt

  echo "Power level: ", power


main()
