import strutils, sequtils, sets, deques

const zero_offset = int('0')
const grid_size = 10

type
    Cell = tuple[row, col: int]
    Grid = array[grid_size, array[grid_size, int]]

proc print(g: Grid) =
    for row in g:
        echo row.join
    echo ""

iterator getNeighbours(g: Grid, row, col: int): Cell =
    for r in row-1..row+1:
        if r < 0 or r > g.high:
            continue

        for c in col-1..col+1:
            if c < 0 or c > g[r].high:
                continue

            if r == row and c == col:
                continue

            yield (r, c)

proc doFlashRec(g: var Grid, row, col: int, flashed: var HashSet[Cell]) =
    flashed.incl((row, col))

    for (r, c) in g.getNeighbours(row, col):
        inc g[r][c]

        if g[r][c] > 9 and (r, c) notin flashed:
            g.doFlashRec(r, c, flashed)

proc doFlashBfs(g: var Grid, doFlash: seq[Cell]): HashSet[Cell] =
    var queue = doFlash.toDeque

    while queue.len > 0:
        let curr = queue.popLast
        if curr in result:
            continue

        result.incl(curr)

        for n in g.getNeighbours(curr.row, curr.col):
            inc g[n.row][n.col]
            if g[n.row][n.col] > 9 and n notin result:
                queue.addFirst(n)

proc doStepRec(g: var Grid): int =
    var flashed: HashSet[Cell]

    for row in 0..g.high:
        for col in 0..g[row].high:
            if g[row][col] > 9 and (row, col) notin flashed:
                g.doFlashRec(row, col, flashed)

    for f in flashed:
        g[f.row][f.col] = 0

    return flashed.len

proc doStepBfs(g: var Grid): int =
    var willFlash: seq[Cell]

    for row in 0..g.high:
        for col in 0..g[row].high:
            if g[row][col] > 9:
                willFlash.add((row, col))

    let flashed = g.doFlashBfs(willFlash)

    for f in flashed:
        g[f.row][f.col] = 0

    return flashed.len

var g: Grid

for rIdx, line in "../input/day11.txt".lines.toSeq.pairs:
    for cIdx, i in line.toSeq.pairs:
        g[rIdx][cIdx] = int(i) - zero_offset

# g.print

var flashes, flashesAt100, syncStep = 0

for i in 1..420:
    for row in 0..g.high:
        for col in 0..g[row].high:
            inc g[row][col]

    let stepFlashes = g.doStepRec
    flashes += stepFlashes

    # part 1
    if i == 100:
        flashesAt100 = flashes

    # part 2
    if stepFlashes == (grid_size * grid_size):
        syncStep = i

    if flashesAt100 != 0 and syncStep != 0:
        break

echo flashesAt100
echo syncStep
