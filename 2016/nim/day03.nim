import strutils, sequtils

proc isValid(a, b, c: int): bool =
    (a + b > c) and (b + c > a) and (a + c > b)

proc isValid(sides: seq[int]): bool =
    isValid(sides[0], sides[1], sides[2])

var numValid, numValid2 = 0

var cols: array[3, seq[int]]

for line in "../input/day3.txt".lines:
    let sides = line.splitWhitespace.map(parseInt)
    if sides.isValid:
        inc numValid

    if cols[0].len < 3:
        cols[0].add(sides[0])
        cols[1].add(sides[1])
        cols[2].add(sides[2])

    if cols[0].len == 3:
        for i in 0..cols.high:
            if cols[i].isValid:
                inc numValid2

            cols[i] = @[]

echo numValid
echo numValid2
