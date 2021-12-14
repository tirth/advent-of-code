import strutils, tables

proc doStep(poly: string, rules: Table[string, string]): string =
    result.add poly[0]

    for i in 0 ..< poly.high:
        result.add rules[poly[i..i + 1]] & poly[i + 1]

proc doStepCounts(pairCounts: Table[string, int], rules: Table[string, char]): Table[string, int] =
    result = pairCounts

    for pair, count in pairCounts:
        if count < 1:
            continue

        let l = rules[pair]
        dec(result[pair], count)
        inc(result[pair[0] & l], count)
        inc(result[l & pair[1]], count)

proc getCharCounts(pairCounts: Table[string, int], firstChar: char): CountTable[char] =
    result = [firstChar].toCountTable

    for pair, count in pairCounts:
        result.inc(pair[1], count)

var poly = ""
var rules: Table[string, char]
var pairCounts: Table[string, int]

# read input
for line in "../input/day14.txt".lines:
    if poly.isEmptyOrWhitespace:
        poly = line
        continue

    if not line.isEmptyOrWhitespace:
        let rSplit = line.split(" -> ")
        rules[rSplit[0]] = rSplit[1][0]
        pairCounts[rSplit[0]] = 0

# initialize pair counts
for i in 0 ..< poly.high:
    inc pairCounts[poly[i..i + 1]]

# iterate
for i in 1..40:
    pairCounts = pairCounts.doStepCounts(rules)

    if i == 10 or i == 40:
        let ct = pairCounts.getCharCounts(poly[0])
        echo ct.largest.val - ct.smallest.val
