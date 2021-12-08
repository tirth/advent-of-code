import sequtils, strutils, tables

iterator getGroups(): seq[string] =
    var group: seq[string]

    for line in "../input/day6.txt".lines:
        if line.isEmptyOrWhitespace:
            yield group
            group = @[]
        else:
            group.add(line)    

    yield group

var numYesAny, numYesAll = 0

for group in getGroups():
    let groupAnswers = group.join
    numYesAny += groupAnswers.deduplicate.len
    numYesAll += groupAnswers.toCountTable.values.countIt(it == group.len)

echo numYesAny
echo numYesAll
