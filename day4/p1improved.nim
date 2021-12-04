import os
import std/[strutils, sets, sequtils]

proc didBoardWin(board: var seq[int], size: int, calledNumbers: var HashSet[int]): bool =
  for i in 0 ..< size:
    var
      rowWon = true
      colWon = true

    let
      col = i
      row = i

    for index in 0 ..< size:
      let
        rowPos = row*size + index
        colPos = col + index*size

      rowWon = rowWon and (board[rowPos] in calledNumbers)
      colWon = colWon and (board[colPos] in calledNumbers)

    if rowWon or colWon:
      return true

  return false

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
      var board = board
      if didBoardWin(board, boardSize, currentNumbers):
        let
          unmarked = toHashSet(board) - currentNumbers
          sum = unmarked.toSeq.foldl(a + b)
        echo "Winner: ", board
        echo "Score: ", sum*num
        return

    index += 1


main()
