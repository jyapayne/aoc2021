import os
import std/strutils

type
  Point = tuple[x, y: int]
  Field = array[1000, array[1000, int]]


template makeLine(field: Field, pointA: Point, pointB: Point) =
  if pointA.x == pointB.x: #vertical
    let top = min(pointA.y, pointB.y)
    let bottom = max(pointA.y, pointB.y)
    for i in top .. bottom:
      field[i][pointA.x] += 1
  elif pointA.y == pointB.y: # horizontal
    let left = min(pointA.x, pointB.x)
    let right = max(pointA.x, pointB.x)
    for i in left .. right:
      field[pointA.y][i] += 1
  else:
    let diagonalLen = abs(pointA.y - pointB.y) + 1

    for i in 0 ..< diagonalLen:
      let offsetX = (if (pointB.x - pointA.x) > 0: i else: -i)
      let offsetY = (if (pointB.y - pointA.y) > 0: i else: -i)
      field[pointA.y+offsetY][pointA.x+offsetX] += 1


proc main() =
  let fileName = paramStr(1)

  var field: Field

  for line in fileName.lines:
    let arrowSplit = line.split(" -> ")
    let leftSplit = arrowSplit[0].split(",")
    let rightSplit = arrowSplit[1].split(",")

    let pointA: Point = (x: leftSplit[0].parseInt, y: leftSplit[1].parseInt)
    let pointB: Point = (x: rightSplit[0].parseInt, y: rightSplit[1].parseInt)

    field.makeLine(pointA, pointB)

  var count = 0
  for i in 0..<field.len:
    for j in 0..<field[0].len:
      if field[i][j] > 1:
        count += 1

  echo "Count: ", count

main()
