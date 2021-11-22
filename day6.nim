from std/strscans import scanf

type 
    LightGrid = array[1000, array[1000, Natural]]

type
    Instruction = enum
        on, off, toggle

type
    Input = tuple[instruction: Instruction, x1: int, y1: int, x2: int, y2: int]

proc getBrightness(grid: LightGrid): int =
    var brightness = 0

    for row in grid:
        for light in row:
            brightness += light

    return brightness

proc command(input: string, instruction: var Instruction, start: int): int = 
    if input[0..5] == "toggle":
        instruction = Instruction.toggle
        return 6

    if input[0..6] == "turn on":
        instruction = Instruction.on
        return 7

    if input[0..7] == "turn off":
        instruction = Instruction.off
        return 8

proc parseInput(rawInstruction: string): Input =
    var inst: Instruction
    var x1, y1, x2, y2: int
    if (scanf(rawInstruction, "${command} $i,$i through $i,$i", inst, x1, y1, x2, y2)):
        return (inst, x1, y1, x2, y2)

proc processLights(lights: var LightGrid, input: Input) =
    let (inst, x1, y1, x2, y2) = input;

    for row in x1..x2:
        for col in y1..y2:
            case inst:
            of on:
                lights[row][col] = 1
            of off:
                lights[row][col] = 0
            of toggle:
                if lights[row][col] == 0:
                    lights[row][col] = 1
                else:
                    lights[row][col] = 0

proc processLightsFancy(lights: var LightGrid, input: Input) =
    let (inst, x1, y1, x2, y2) = input;

    for row in x1..x2:
        for col in y1..y2:
            case inst:
            of on:
                inc lights[row][col]
            of off:
                if lights[row][col] > 0:
                    dec lights[row][col]
            of toggle:
                lights[row][col] += 2


var lights: LightGrid
var fancyLights: LightGrid

for instruction in "day6_input.txt".lines:
    let input = parseInput(instruction)

    processLights(lights, input)
    processLightsFancy(fancyLights, input)

echo lights.getBrightness
echo fancyLights.getBrightness

