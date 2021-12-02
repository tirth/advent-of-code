import strutils, sets

type
    Position = tuple[x, y: int]

proc toDistance(position: Position): int =
    position.x.abs + position.y.abs

proc `$`(position: Position): string =
    $position.x & "," & $position.y

var visited: HashSet[string]
var foundFirst = false
var firstIntercept: Position

proc logAllVisited(position: Position, heading, distance: int) =
    if foundFirst:
        return

    var pos: Position

    for i in 1..distance:
        case heading
        of 0:
            pos = (position.x, position.y + i)
        of 1:
            pos = (position.x + i, position.y)
        of 2:
            pos = (position.x, position.y - i)
        of 3:
            pos = (position.x - i, position.y)
        else:
            discard

        if $pos in visited:
            foundFirst = true
            firstIntercept = pos
        else:
            visited.incl($pos)

var position: Position = (0, 0)
var heading = 0

for instruction in readFile("../input/day1.txt").split(", "):
    let direction = instruction[0]
    let distance = instruction[1..instruction.high].parseInt

    case direction
    of 'R':
        heading = heading + 1
        if heading > 3:
            heading = 0
    of 'L':
        heading = heading - 1
        if heading < 0:
            heading = 3
    else:
        discard   

    case heading:
    of 0:
        logAllVisited(position, heading, distance)
        position.y += distance
    of 1:
        logAllVisited(position, heading, distance)
        position.x += distance
    of 2:
        logAllVisited(position, heading, distance)
        position.y -= distance
    of 3:
        logAllVisited(position, heading, distance)
        position.x -= distance
    else:
        discard

echo position.toDistance
echo firstIntercept.toDistance