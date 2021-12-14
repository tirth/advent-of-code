import strutils, sequtils, sets, math, strformat, algorithm, deques

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

proc getBasin(row, col: int, basinPoints: var HashSet[string]) =
    basinPoints.incl(fmt"{row},{col}")

    for (r, c, v) in getNeighbourVals(row, col):
        if v != 9 and fmt"{r},{c}" notin basinPoints:
            getBasin(r, c, basinPoints)

proc getBasinDfs(row, col: int): int =
    var 
        visited: HashSet[Cell]
        stack: Deque[Cell] = [(row, col)].toDeque
 
    while stack.len > 0:
        let curr = stack.popFirst
        if curr notin visited:
            visited.incl(curr)
 
            if g[curr.row][curr.col] != 9:
                inc result
 
                for n in getNeighbours(curr.row, curr.col):
                    if n notin visited:
                        stack.addFirst(n)

var lowPoints, basinSizes: seq[int]

for row in 0..g.high:
    for col in 0..g[row].high:
        let val = g[row][col]

        if getNeighbourVals(row, col).toSeq.anyIt(val >= it.val):
            continue
    
        lowPoints.add(val)

        # var basinPoints = initHashSet[string](g.len * g.len)
        # getBasin(row, col, basinPoints)
        # let basinSize = basinPoints.len

        let basinSize = getBasinDfs(row, col)
        basinSizes.insert(basinSize, basinSizes.lowerBound(basinSize))

echo lowPoints.sum + lowPoints.len
echo basinSizes[^3..^1].foldl(a * b)
