import os
import std/strutils

template mapClosing(open: char): char =
  case open:
  of '(': ')'
  of '[': ']'
  of '{': '}'
  of '<': '>'
  else: '\0'

template points(c: char): int =
  case c:
  of ')':
    3
  of ']':
    57
  of '}':
    1197
  of '>':
    25137
  else:
    0

proc main() =
  let fileName = paramStr(1)

  var points = 0
  for line in fileName.lines:
    var stack: seq[char]

    for c in line:
      case c:
      of '[', '(', '{', '<':
        stack.add(c)
      of ']', ')', '}', '>':
        if mapClosing(stack[^1]) == c:
          discard stack.pop()
        else:
          points += c.points
          break
      else: discard


  echo "Points: ", points

main()
