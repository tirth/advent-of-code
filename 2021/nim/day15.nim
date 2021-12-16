import astar, sequtils

const directions = [
    [-1, 0], # up
    [1, 0],  # down
    [0, -1], # left
    [0, 1]   # right
]

type
    Grid = seq[seq[int]]
    Point = tuple[x, y: int]

iterator neighbors(grid: Grid, point: Point): Point =
    for (x, y) in directions.mapIt((point.x + it[1], point.y + it[0])):
        if y >= 0 and y <= grid.high and x >= 0 and x <= grid[y].high:
            yield (x, y)

proc cost(grid: Grid, a, b: Point): int =
    grid[a.y][a.x]

proc heuristic(grid: Grid, node, goal: Point): int =
    manhattan[Point, int](node, goal)

proc incrementRisk(current: int, amount: int): int =
    result = current + amount
    while result > 9:
        result -= 9

# TODO: virtualized expanded grid
proc expandGrid(grid: Grid, size: int): Grid =
    result.newSeq(grid.len * size)
    for y in 0..result.high:
        result[y].newSeq(grid.len * size)

    for i in 0 ..< size:
        for j in 0 ..< size:
            for y in 0 .. grid.high:
                for x in 0 .. grid[y].high:
                    result[y + (i * grid.len)][x + (j * grid[y].len)] = grid[y][x].incrementRisk(i + j)

proc bestPath(grid: Grid): int =
    let start = (0, 0)
    let goal = (grid.high, grid[0].high)

    for point in path[Grid, Point, int](grid, start, goal):
        if point != start:
            result += grid[point.y][point.x]

var grid: Grid
for line in "../input/day15.txt".lines:
    grid.add(line.toSeq.mapIt(int(it) - int('0')))

echo grid.bestPath
echo grid.expandGrid(5).bestPath
