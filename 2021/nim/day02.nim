import strutils

var horizontalPos, depth, aim = 0
for line in "../input/day2.txt".lines:
    let sp = line.split(' ')
    let direction = sp[0]
    let amount = sp[1].parseInt

    case direction
    of "forward":
        horizontalPos += amount
        depth += aim * amount
    of "down":
        aim += amount
    of "up":
        aim -= amount

# horizontal position is the same for both parts,
# aim acts as depth
echo horizontalPos * aim
echo horizontalPos * depth
