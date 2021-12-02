import algorithm, math

type
    Seat = tuple[row, col: int]

const row_len = 7
const col_len = 3

proc parsePass(pass: string): Seat =
    var minRow, minCol = 0
    var maxRow = (2 ^ rowLen) - 1
    var maxCol = (2 ^ colLen) - 1

    for c in pass:
        case c:
        of 'F':
            maxRow -= len(minRow..maxRow) div 2
        of 'B':
            minRow += len(minRow..maxRow) div 2
        of 'L':
            maxCol -= len(minCol..maxCol) div 2
        of 'R':
            minCol += len(minCol..maxCol) div 2
        else:
            raise newException(Exception, "parsing error")

    if minRow != maxRow or minCol != maxCol:
        raise newException(Exception, "parsing error")

    (minRow, minCol)

proc calcId(seat: Seat): int =
    (seat.row * 8) + seat.col

var ids: seq[int]
for line in "../input/day5.txt".lines:
    ids.add(parsePass(line).calcId)

ids.sort()
echo ids[^1]

for i in 1 .. ids.high - 1:
    if ids[i] != ids[i - 1] + 1:
        echo ids[i] - 1
        break