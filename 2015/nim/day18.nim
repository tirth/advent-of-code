import sequtils

type
    Lights = seq[seq[bool]]

proc echoLights(lights: Lights) =
    for row in lights:
        var rowStr: string

        for light in row:
            rowStr = rowStr & (if light: "#" else: ".")

        echo rowStr
    echo ""

proc lightsOn(lights: Lights): int =
    for row in lights:
        result += row.countIt(it)

proc getNeighbourLights(lights: Lights, row: int, col: int): seq[bool] =
    for r in row - 1 .. row + 1:
        if r < 0 or r >= lights.len:
            continue

        for c in col - 1 .. col + 1:
            if c < 0 or c >= lights[r].len:
                continue

            if r == row and c == col:
                continue

            result.add(lights[r][c])


proc iterateLights(lights: Lights, cornerStuck: bool = false): Lights =
    for r, row in lights:
        var newRow: seq[bool]

        for c, light in row:
            let lit = getNeighbourLights(lights, r, c).countIt(it)

            var nextLit = if light: lit == 2 or lit == 3 else : lit == 3

            if cornerStuck:
                if r == 0 and (c == 0 or c == row.high):
                    nextLit = true
                elif r == lights.high and (c == 0 or c == row.high):
                    nextLit = true

            newRow.add(nextLit)

        result.add(newRow)


var lights: Lights
for line in "../input/day18.txt".lines:
    var row: seq[bool]
    for light in line:
        row.add(light == '#')
    lights.add(row)

# echoLights(lights)

var lights1 = lights
for i in 1..100:
    lights1 = iterateLights(lights1)
    # echoLights(lights1)

echo lightsOn(lights1)

var lights2 = lights
for i in 1..100:
    lights2 = iterateLights(lights2, true)
    # echoLights(lights2)

echo lightsOn(lights2)