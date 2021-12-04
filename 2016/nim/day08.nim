import sequtils, strutils, algorithm, math

const screen_height = 6
const screen_width = 50

type
    Screen = array[screen_height, array[screen_width, bool]]

proc display(screen: Screen) =
    for row in screen:
        echo row.mapIt(if it: '#' else: '.').join

proc numLit(screen: Screen): int =
    for row in screen:
        result += row.mapIt(if it: 1 else: 0).sum

proc rect(screen: var Screen, width, height: int) =
    for y in 0..<height:
        for x in 0..<width:
            screen[y][x] = true

proc rotateRow(screen: var Screen, row, by: int) =
    screen[row].rotateLeft(-by)

proc rotateCol(screen: var Screen, col, by: int) =
    let colVals = screen.mapIt(it[col]).rotatedLeft(-by)
    for i in 0..screen.high:
        screen[i][col] = colVals[i]

var screen: Screen

for line in "../input/day8.txt".lines:
    let instr = line.splitWhitespace

    if instr[0] == "rect":
        let nums = instr[1].split('x').map(parseInt)
        screen.rect(nums[0], nums[1])
    else:
        let xOrY = instr[2].split('=')[^1].parseInt
        let by = instr[4].parseInt

        case instr[1]:
        of "column":
            screen.rotateCol(xOrY, by)
        of "row":
            screen.rotateRow(xOrY, by)

echo screen.numLit
display screen