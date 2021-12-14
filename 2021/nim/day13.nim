import strutils, sequtils

const grid_size = 1500

type
    Grid = array[grid_size, array[grid_size, bool]]
    Fold = tuple[dir: string, pos: int]

proc gridStr(g: Grid, height: int = 6, width: int = 40): string =
    for y in 0 ..< height:
        for x in 0 ..< width:
            result.add (if g[y][x]: "#" else: ".")
        result.add "\n"

proc dotCount(g: Grid): int =
    for row in g:
        result += row.countIt(it)

var g: Grid
var folds: seq[Fold]

# TODO: implement without grid, just using points
for line in "../input/day13.txt".lines:
    if "," in line:
        let pSplit = line.split(",").map(parseInt)
        g[pSplit[1]][pSplit[0]] = true
    elif "fold" in line:
        let fSplit = line.splitWhitespace[^1].split("=")
        folds.add((fSplit[0], fSplit[1].parseInt))

var firstCount = -1

for (dir, pos) in folds:
    case dir:
    of "y":
        for y in pos..g.high:
            for x in 0..g[y].high:
                if g[y][x]:
                    g[pos - (y - pos)][x] = true
                    g[y][x] = false

    of "x":
        for y in 0..g.high:
            for x in pos..g[y].high:
                if g[y][x]:
                    g[y][pos - (x - pos)] = true
                    g[y][x] = false

    if firstCount == -1:
        firstCount = g.dotCount

echo firstCount
echo g.gridStr
