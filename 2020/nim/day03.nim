import sequtils, strutils

type
    Forest = seq[seq[bool]]

proc checkSlope(forest: Forest, right, down: int): int = 
    for i in 1..forest.high div down:
        let y = (i * down) mod forest.len
        let x = (i * right) mod forest[i].len
        if forest[y][x]:
            inc result

let forest = "../input/day3.txt".readFile.splitLines.mapIt(it.mapIt(it == '#'))

echo forest.checkSlope(3, 1)

var treeProduct = 1
for (right, down) in [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]:
    treeProduct *= forest.checkSlope(right, down)

echo treeProduct
