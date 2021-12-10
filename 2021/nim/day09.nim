import strutils, sequtils, sets, math, strformat, algorithm

type
    Cell = tuple[row, col: int]
    CellVal = tuple[row, col, val: int]
    Grid = seq[seq[int]]

const zero_offset = int('0')

let g: Grid = "../input/day9.txt".lines.toSeq.mapIt(it.mapIt(int(it) - zero_offset))

iterator getNeighbours(row, col: int): Cell =
    # up
    if row != 0:
        yield (row - 1, col)

    # down
    if row != g.high:
        yield (row + 1, col)

    # left
    if col != 0:
        yield (row, col - 1)

    # right
    if col != g[row].high:
        yield (row, col + 1)

iterator getNeighbourVals(row, col: int): CellVal =
    for r, c in getNeighbours(row, col):
        yield (r, c, g[r][c])

# TODO: recurse properly
var basinPoints: HashSet[string]

proc getBasin(row, col: int) =
    basinPoints.incl(fmt"{row},{col}")

    for (r, c, v) in getNeighbourVals(row, col):
        if v != 9 and fmt"{r},{c}" notin basinPoints:
            getBasin(r, c)

var lowPoints, basinSizes: seq[int]

for row in 0..g.high:
    for col in 0..g[row].high:
        let val = g[row][col]

        if getNeighbourVals(row, col).toSeq.anyIt(val >= it.val):
            continue
    
        lowPoints.add(val)

        getBasin(row, col)

        let basinSize = basinPoints.len
        basinSizes.insert(basinSize, basinSizes.lowerBound(basinSize))

        basinPoints.clear()

echo lowPoints.sum + lowPoints.len
echo basinSizes[^3..^1].foldl(a * b)
