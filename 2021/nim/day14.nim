import strutils, tables

proc doStep(poly: string, rules: Table[string, char]): string =
    result.add poly[0]

    for i in 0 ..< poly.high:
        result.add rules[poly[i..i + 1]] & poly[i + 1]

proc doStepCounts(pairCounts: CountTable[string], rules: Table[string, char]): CountTable[string] =
    for pair, count in pairCounts:
        let l = rules[pair]
        result.inc(pair[0] & l, count)
        result.inc(l & pair[1], count)

proc getCharCounts(pairCounts: CountTable[string], firstChar: char): CountTable[char] =
    result.inc(firstChar)

    for pair, count in pairCounts:
        result.inc(pair[1], count)

var poly = ""
var rules: Table[string, char]
var pairCounts: CountTable[string]

# read input
for line in "../input/day14.txt".lines:
    if poly.isEmptyOrWhitespace:
        poly = line
        continue

    if not line.isEmptyOrWhitespace:
        let rSplit = line.split(" -> ")
        rules[rSplit[0]] = rSplit[1][0]

# initialize pair counts
for i in 0 ..< poly.high:
    pairCounts.inc(poly[i..i + 1])

# iterate
for i in 1..40:
    pairCounts = pairCounts.doStepCounts(rules)

    if i == 10 or i == 40:
        let ct = pairCounts.getCharCounts(poly[0])
        echo ct.largest.val - ct.smallest.val
