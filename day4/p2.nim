import os
import std/[strutils, enumerate, sets, sequtils]

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
  for row in 0 ..< size:
    if didRowWin(board, size, row, calledNumbers):
      return true

  for col in 0 ..< size:
    if didColumnWin(board, size, col, calledNumbers):
      return true


proc main() =
  let
    fileName = paramStr(1)
    file = open(fileName, fmRead)
    allNumbers = toSeq(file.readLine().split(",").mapIt(it.parseInt))

  discard file.readLine()

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
    boardsNotWon = toHashSet(toSeq(0..<boards.len))

  while len(currentNumbers) < len(allNumbers):
    let num = allNumbers[index]

    currentNumbers.incl(num)
    var boardsNotWonCopy = boardsNotWon
    for boardIndex in boardsNotWonCopy:
      let board = boards[boardIndex]
      if didBoardWin(board, boardSize, currentNumbers):

        if boardsNotWon.len() == 1:
          let
            unmarked = toHashSet(board) - currentNumbers
            sum = unmarked.toSeq.foldl(a + b)
          echo "Winner: ", board
          echo "Score: ", sum*num
          return
        boardsNotWon.excl(boardIndex)

    index += 1


main()
