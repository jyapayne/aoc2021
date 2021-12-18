import os, bitops, sugar
import std/[strutils, sequtils]

type
  ReadResult =
    tuple[value: int, bitsRead: int]

  ParseResult = int

  PacketType = enum
    Sum
    Product
    Minimum
    Maximum
    Literal
    GreaterThan
    LessThan
    Equal


proc hexToBin(hex: char): int {.inline.} =
  case hex:
  of '0': 0b0000
  of '1': 0b0001
  of '2': 0b0010
  of '3': 0b0011
  of '4': 0b0100
  of '5': 0b0101
  of '6': 0b0110
  of '7': 0b0111
  of '8': 0b1000
  of '9': 0b1001
  of 'A', 'a': 0b1010
  of 'B', 'b': 0b1011
  of 'C', 'c': 0b1100
  of 'D', 'd': 0b1101
  of 'E', 'e': 0b1110
  of 'F', 'f': 0b1111
  else: 0

template readBits(packet: string, numBits: int): ReadResult =
  let bytesToRead = (((bitPos mod 4) + numBits) div 4) + 1
  var skipBits = bitPos mod 4
  var numBitsToRead = numBits
  var res: ReadResult

  var i = 0
  while numBitsToRead > 0 and i < bytesToRead and ((bitPos div 4) + i) < packet.len:
    var bin = packet[(bitPos div 4) + i].hexToBin

    var currentBit = 4

    case skipBits:
    of 1: currentBit = 3
    of 2: currentBit = 2
    of 3: currentBit = 1
    else: discard

    skipBits = 0

    while currentBit > 0 and numBitsToRead > 0:
      let currentBVal = bin.testBit(currentBit - 1).int
      res.value += currentBVal shl (numBitsToRead - 1)
      res.bitsRead += 1
      currentBit -= 1
      numBitsToRead -= 1

    i.inc

  bitPos += res.bitsRead
  res

template readLiteral(packet: string): ReadResult =
  var
    indicator = packet.readBits(1)
    nextSection: ReadResult
    res: ReadResult

  res.bitsRead += indicator.bitsRead

  while indicator.value == 1:
    nextSection = packet.readBits(4)

    res.value = res.value shl 4
    res.value += nextSection.value
    res.bitsRead += nextSection.bitsRead

    indicator = packet.readBits(1)
    res.bitsRead += indicator.bitsRead

  # read the last line
  nextSection = packet.readBits(4)

  res.value = res.value shl 4
  res.value += nextSection.value
  res.bitsRead += nextSection.bitsRead

  res

proc parsePacket(packet: string, bitPos: var int, verSum: var int): ParseResult =
  let
    version = packet.readBits(3)
    packetType = packet.readBits(3)

  verSum += version.value

  var operation: (int, int) -> int

  case packetType.value.PacketType:
  of Literal:
    # Read Literal value
    return packet.readLiteral().value
  of Sum:
    operation = (x, y: int) => x + y
  of Product:
    operation = (x, y: int) => x * y
  of Minimum:
    operation = (x, y: int) => min(x, y)
  of Maximum:
    operation = (x, y: int) => max(x, y)
  of GreaterThan:
    operation = (x, y: int) => (x > y).int
  of LessThan:
    operation = (x, y: int) => (x < y).int
  of Equal:
    operation = (x, y: int) => (x == y).int

  let lengthTypeId = packet.readBits(1)
  var acc: seq[int]

  if lengthTypeId.value == 0:
    # 15 bit mode
    let subPacketLen = packet.readBits(15).value
    var
      bitsRead = 0
      initialBitPos = bitPos

    while bitsRead < subPacketLen:
      acc.add packet.parsePacket(bitPos, verSum)
      bitsRead = bitPos - initialBitPos

  else:
    # 11 bit mode
    let numSubPackets = packet.readBits(11).value
    for i in 0 ..< numSubPackets:
      acc.add packet.parsePacket(bitPos, verSum)

  return acc.foldl(operation(a, b))

proc main() =
  let
    fileName = paramStr(1)
  var packet: string
  try:
    packet = fileName.readFile().strip()
  except IOError:
    packet = paramStr(1)

  var bitPos = 0
  var verSum = 0

  echo packet.parsePacket(bitPos, verSum)

main()
