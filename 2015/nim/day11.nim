from sequtils import any, anyIt
from strutils import join
from sugar import collect

const minVal = int8('a')

proc stringToCharCodeSeq(input: string): seq[int8] =
    return collect(newSeqOfCap(input.len)):
        for c in input:
            int8(c) - minVal

proc charCodeSeqToString(chars: seq[int8]): string =
    let letters = collect(newSeqOfCap(chars.len)):
        for c in chars:
            char(c + minVal)

    return letters.join("")

proc incrementPassword(input: string): string = 
    var chars = stringToCharCodeSeq(input)

    for i in countdown(chars.len - 1, -1):
        if i == -1:
            raise newException(Exception, "buffer overflow")

        inc chars[i]
        if chars[i] == 26:
            chars[i] = 0
        else:
            break

    return charCodeSeqToString(chars)

let forbiddenLetters = stringToCharCodeSeq("iol")

proc checkForbidden(chars: seq[int8]): bool =
    return not forbiddenLetters.anyIt(chars.contains(it))

proc checkRun(chars: seq[int8]): bool =
    var lastChar = chars[0]
    var runLen = 1

    for c in chars[1..<chars.len]:
        if c == (lastChar + 1):
            inc runLen
            if runLen >= 3:
                return true
        else:
            runLen = 1

        lastChar = c

proc checkPair(chars: seq[int8]): bool =
    var lastChar = chars[0]
    var pairs: seq[int]

    for c in chars[1..<chars.len]:
        if c == lastChar and not pairs.contains(c):
            pairs.add(c)
            if pairs.len >= 2:
                return true

        lastChar = c

proc passwordValid(input: string): bool = 
    let chars = stringToCharCodeSeq(input)
    return chars.checkForbidden and chars.checkRun and chars.checkPair

var input = "vzbxkghb"

while not passwordValid(input):
    input = incrementPassword(input)

echo input

input = incrementPassword(input)

while not passwordValid(input):
    input = incrementPassword(input)

echo input