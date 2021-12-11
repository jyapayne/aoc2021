import os
import std/[strformat, algorithm]

proc mapClosing(open: char): char {.inline.} =
  case open:
  of '(': ')'
  of '[': ']'
  of '{': '}'
  of '<': '>'
  else: '\0'

proc points(c: char): int {.inline.} =
  case c:
  of ')': 1
  of ']': 2
  of '}': 3
  of '>': 4
  else: 0

proc main() =
  let fileName = paramStr(1)

  var pointList: seq[int]

  for line in fileName.lines:
    var stack: seq[char]

    var points = 0
    var error = false
    for c in line:
      case c:
      of '[', '(', '{', '<':
        stack.add(c)
      of ']', ')', '}', '>':
        if mapClosing(stack[^1]) == c:
          discard stack.pop()
        else:
          echo fmt"Syntax error. Got {c}, expected {mapClosing(stack[^1])}"
          error = true
          break
      else: discard

    while not error and stack.len > 0:
      points *= 5
      points += mapClosing(stack.pop).points

    if not error:
      pointList.add points



  echo "Points: ", pointList.sorted[pointList.len div 2]

main()
