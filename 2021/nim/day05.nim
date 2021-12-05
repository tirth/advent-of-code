import strutils, sequtils, strscans

const grid_size = 1000

type
    Point = tuple[x, y: int]
    Grid = array[grid_size, array[grid_size, int]]

proc showGrid(grid: Grid) =
    for row in grid:
        echo row.mapIt(if it == 0: "." else: $it).join

proc numOverlap(grid: Grid): int =
    for row in grid:
        for cell in row:
            if cell >= 2:
                inc result

proc parseLine(line: string): tuple[p1, p2: Point] =
    let (success, x1, y1, x2, y2) = scanTuple(line, "$i,$i -> $i,$i")
    if not success:
        raise newException(Exception, "parsing error")

    return ((x1, y1), (x2, y2))

proc processLine(grid: var Grid, p1, p2: Point, allowDiagonal: bool = false) =
    let m = ((p2.y - p1.y) / (p2.x - p1.x)).toInt

    # horizontal and diagonal
    if m in [0, 1, -1]:
        if not allowDiagonal and m != 0:
            return

        let b = p1.y - (m * p1.x)
        for x in min(p1.x, p2.x) .. max(p1.x, p2.x):
            inc grid[(m * x) + b][x]

    # vertical
    elif p1.x == p2.x:
        for y in min(p1.y, p2.y) .. max(p1.y, p2.y):
            inc grid[y][p1.x]

    else:
        raise newException(Exception, "unhandled line: " & $m)

var grid, grid2: Grid

for line in "../input/day5.txt".lines:
    let (p1, p2) = line.parseLine

    grid.processLine(p1, p2)
    grid2.processLine(p1, p2, true)

# grid.showGrid
echo grid.numOverlap
echo grid2.numOverlap
