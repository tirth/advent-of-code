import strscans, tables

type
    Sue = tuple[number: int, things: Table[string, int]]

proc parseSue(input: string): Sue =
    let (success, sueNum, thing1, num1, thing2, num2, thing3, num3) = scanTuple(input, "Sue $i: $w: $i, $w: $i, $w: $i")
    if not success:
        raise newException(Exception, "parsing error")
    
    return (sueNum, [(thing1, num1), (thing2, num2), (thing3, num3)].toTable)

proc checkLine(sue: Sue, tag: string, val: int, mightBeRange: bool = false): bool =
    if not (tag in sue.things):
        return true

    if not mightBeRange:
        return sue.things[tag] == val

    case tag:
    of "cats", "trees":
        return sue.things[tag] > val
    of "pomeranians", "goldfish":
        return sue.things[tag] < val
    else:
        return sue.things[tag] == val

let criteria = {
    "children": 3,
    "cats": 7,
    "samoyeds": 2,
    "pomeranians": 3,
    "akitas": 0,
    "vizslas": 0,
    "goldfish": 5,
    "trees": 3,
    "cars": 2,
    "perfumes": 1
}.toTable

var sues: seq[Sue]
for line in "input/day16.txt".lines:
    sues.add(parseSue(line))

var part1, part2: Sue

for sue in sues:
    var matches1, matches2 = true
    for tag, val in criteria:
        matches1 = matches1 and checkLine(sue, tag, val)
        matches2 = matches2 and checkLine(sue, tag, val, true)

    if matches1:
        part1 = sue
    
    if matches2:
        part2 = sue

echo part1.number
echo part2.number