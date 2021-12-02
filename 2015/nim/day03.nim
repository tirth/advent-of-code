import std/critbits

proc updateLocation(direction: char, location: var tuple[x: int, y: int]) = 
    case direction
    of '^': inc location.y
    of 'v': dec location.y
    of '>': inc location.x
    of '<': dec location.x
    else: discard

proc housesVisited(directions: string): int =
    var location : tuple[x: int, y: int] = (0, 0)

    var visited = [$location].toCritBitTree()

    for direction in directions:
        updateLocation(direction, location)
        visited.incl($location)

    return visited.len()

type
    Santa = enum
        norm, robo

proc roboHousesVisited(directions: string): int =
    var normSanta : tuple[x: int, y: int] = (0, 0)
    var roboSanta : tuple[x: int, y: int] = (0, 0)

    var visited = [$normSanta].toCritBitTree()

    var currentSanta = Santa.norm

    for direction in directions:
        case currentSanta
        of norm:
            updateLocation(direction, normSanta)
            visited.incl($normSanta)
            currentSanta = Santa.robo
        of robo:
            updateLocation(direction, roboSanta)
            visited.incl($roboSanta)
            currentSanta = Santa.norm

    return visited.len()

let directions = readFile("../input/day3.txt")

echo housesVisited(directions)
echo roboHousesVisited(directions)