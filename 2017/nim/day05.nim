import strutils, sequtils

proc escapeList(instructions: seq[int], fancy: bool = false): int =
    var 
        instructions = instructions
        currentIdx = 0

    while currentIdx >= 0 and currentIdx <= instructions.high:
        inc result

        var curr = instructions[currentIdx]
        if fancy and curr >= 3:
            dec instructions[currentIdx]
        else:
            inc instructions[currentIdx]

        currentIdx += curr

    return result

let nums = "../input/day5.txt".readFile.splitLines.map(parseInt)

echo nums.escapeList
echo nums.escapeList(true)