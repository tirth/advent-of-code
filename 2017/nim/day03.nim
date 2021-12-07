import math, strutils, tables, times, std/monotimes

const grid_size = 1000
const grid_offset = grid_size div 2

type
    Coord = tuple[x, y: int]
    Grid = array[grid_size, array[grid_size, int]]

var grid: Grid

proc getGrid(x, y: int): int =
    grid[x + grid_offset][y + grid_offset]

proc gridSum(x, y: int): int =
    for i in x-1 .. x+1:
        for j in y-1 .. y+1:
            if i == x and j == y:
                continue

            result += getGrid(i, j)

proc setGrid(x, y, val: int): int =
    grid[x + grid_offset][y + grid_offset] = val

    return val

proc updateGrid(x, y: int): int =
    setGrid(x, y, gridSum(x, y))

proc getCoord(at: int, doGrid: bool = false): Coord =
    var num, currX, currY = 0
    
    inc num
    discard setGrid(currX, currY, 1)
    if num == at:
        return (currX, currY)

    for p in 2..1000:
        let evenP = p mod 2 == 0
        
        if evenP:
            inc currX
        else:
            dec currX

        inc num
        if doGrid:
            let sum = updateGrid(currX, currY)
            if sum > at:
                echo sum
                return

        if num == at:
            return (currX, currY)
        
        for b in 0..<p - 1:
            currY += (if evenP: 1 else: -1)

            inc num
            if doGrid:
                let sum = updateGrid(currX, currY)
                if sum > at:
                    echo sum
                    return

            if num == at:
                return (currX, currY)

        for b in 0..<p - 1:
            currX += (if evenP: -1 else: 1)
            
            inc num
            if doGrid:
                let sum = updateGrid(currX, currY)
                if sum > at:
                    echo sum
                    return

            if num == at:
                return (currX, currY)

proc getDist(coord: Coord): int =
    coord.x.abs + coord.y.abs

let start = getMonoTime()

echo getCoord(312051).getDist
discard getCoord(312051, true)

# for num in 1..100:
#     echo num, ", ", getCoord(num).getDist

# echo getMonoTime() - start