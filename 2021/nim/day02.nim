import strutils

proc move1(direction: string, amount: int, horizontalPos, depth: var int) =
    case direction
    of "forward":
        horizontalPos += amount
    of "down":
        depth += amount
    of "up":
        depth -= amount

proc move2(direction: string, amount: int, horizontalPos, depth, aim: var int) =
    case direction
    of "forward":
        horizontalPos += amount
        depth += aim * amount
    of "down":
        aim += amount
    of "up":
        aim -= amount

var hor1, dep1, hor2, dep2, aim = 0
for line in "../input/day2.txt".lines:
    let sp = line.split(' ')
    let dir = sp[0]
    let amt = sp[1].parseInt

    move1(dir, amt, hor1, dep1)
    move2(dir, amt, hor2, dep2, aim)

echo hor1 * dep1
echo hor2 * dep2
