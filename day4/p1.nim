import os
import std/[strutils, sets, sequtils]

proc didColumnWin(board: seq[int], size: int, col: int, calledNumbers: HashSet[int]): bool =
  for i in 0 ..< size:
    let el = board[col + i*size]
    if not calledNumbers.contains(el):
      return false

  return true

proc didRowWin(board: seq[int], size: int, row: int, calledNumbers: HashSet[int]): bool =

  for i in 0 ..< size:
    if not calledNumbers.contains(board[row*size + i]):
      return false

  return true


proc didBoardWin(board: seq[int], size: int, calledNumbers: HashSet[int]): bool =
  for i in 0 ..< size:
    if didRowWin(board, size, i, calledNumbers):
      return true

    if didColumnWin(board, size, i, calledNumbers):
      return true


proc main() =
  let
    fileName = paramStr(1)
    file = open(fileName, fmRead)
    allNumbers = toSeq(file.readLine().split(",").mapIt(it.parseInt))

  discard file.readLine() # skip blank line

  var boards: seq[seq[int]]
  boards.add(newSeq[int]())

  var
    boardIndex = 0
    boardSize = 0

  while not file.endOfFile():
    let line = file.readLine()

    if line.strip() == "":
      boards.add(newSeq[int]())
      boardIndex += 1
    else:
      let board = line.strip().splitWhitespace().mapIt(it.parseInt)
      boardSize = board.len
      boards[boardIndex].add(board)


  var
    currentNumbers: HashSet[int]
    index = 0

  while len(currentNumbers) < len(allNumbers):
    let num = allNumbers[index]

    currentNumbers.incl(num)

    for board in boards:
      if didBoardWin(board, boardSize, currentNumbers):
        let
          unmarked = toHashSet(board) - currentNumbers
          sum = unmarked.toSeq.foldl(a + b)
        echo "Winner: ", board
        echo "Score: ", sum*num
        return

    index += 1


main()
