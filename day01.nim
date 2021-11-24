proc getFloor(directions: string): int =
    for direction in directions:
        case direction:
        of '(': inc result
        of ')': dec result
        else: discard

proc getPositionInBasement(directions: string): int =
    var currentFloor = 0

    for idx, direction in directions:
        case direction:
        of '(': inc currentFloor
        of ')': dec currentFloor
        else: discard

        if currentFloor == -1:
            return idx + 1
     
    return -1

let directions = readFile("input/day1.txt")

echo getFloor(directions)
echo getPositionInBasement(directions)