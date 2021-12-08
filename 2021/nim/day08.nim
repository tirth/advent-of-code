import sequtils, strutils, tables, algorithm, sugar

template first(s, pred: untyped): untyped =
    var result = newSeqOfCap[typeof(s[0])](1)
    for it {.inject.} in items(s):
        if pred:
            result.add(it)
            break

    if result.len < 1:
        raise newException(Exception, "no items matched for first")

    result[0]

var uniqueCounts, valueSum = 0

# NB: need trailing space in last line for some reason
for line in "../input/day8.txt".lines:
    let lineSp = line.split('|').mapIt(it.splitWhitespace.mapIt(it.sortedByIt(it).join))
    let patterns = lineSp[0]
    let outputVals = lineSp[1]

    let one = patterns.first(it.len == 2)
    let seven = patterns.first(it.len == 3)
    let four = patterns.first(it.len == 4)
    let eight = patterns.first(it.len == 7)

    let nine = patterns.first(it.len == 6 and four.all(f => f in it))

    let realE = eight.first(it notin nine)

    let zero = patterns.first(it.len == 6 and realE in it and one.all(o => o in it))
    let six = patterns.first(it.len == 6 and it != zero and it != nine)

    let realC = eight.first(it notin six)

    let five = patterns.first(it.len == 5 and realC notin it)
    let two = patterns.first(it.len == 5 and realE in it)
    let three = patterns.first(it.len == 5 and it != two and it != five)

    let realVals = {
        zero: 0,
        one: 1,
        two: 2,
        three: 3,
        four: 4,
        five: 5,
        six: 6,
        seven: 7,
        eight: 8,
        nine: 9
    }.toTable

    let outputV = outputVals.mapIt(realVals[it])

    uniqueCounts += outputV.countIt(it in [1, 4, 7, 8])
    valueSum += outputV.join.parseInt

echo uniqueCounts
echo valueSum
