import strutils

type
    Key = tuple[y, x: int]

const keypad1 = [['1', '2', '3'], ['4', '5', '6'], ['7', '8', '9']]

const X = 'X'
const keypad2 = [[X, X, '1', X, X], [X, '2', '3', '4', X], ['5', '6', '7', '8', '9'], [X, 'A', 'B', 'C', X], [X, X, 'D', X, X]]

var currentKey1: Key = (1, 1)
var currentKey2: Key = (2, 0)
var keys1, keys2: seq[char]
for line in "../input/day2.txt".lines:
    for direction in line:
        case direction:
        of 'D':
            if currentKey1.y < keypad1.high:
                inc currentKey1.y

            if currentKey2.y < keypad2.high and (keypad2[currentKey2.y + 1][currentKey2.x] != X):
                inc currentKey2.y
        of 'U':
            if currentKey1.y > 0:
                dec currentKey1.y

            if currentKey2.y > 0 and (keypad2[currentKey2.y - 1][currentKey2.x] != X):
                dec currentKey2.y
        of 'R':
            if currentKey1.x < keypad1[currentKey1.y].high:
                inc currentKey1.x

            if currentKey2.x < keypad2[currentKey2.y].high and (keypad2[currentKey2.y][currentKey2.x + 1] != X):
                inc currentKey2.x
        of 'L':
            if currentKey1.x > 0:
                dec currentKey1.x

            if currentKey2.x > 0 and (keypad2[currentKey2.y][currentKey2.x - 1] != X):
                dec currentKey2.x
        else:
            discard

    keys1.add(keypad1[currentKey1.y][currentKey1.x])
    keys2.add(keypad2[currentKey2.y][currentKey2.x])

echo keys1.join
echo keys2.join
