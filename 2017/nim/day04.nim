import strutils, sequtils, algorithm

var valid, valid2 = 0
for line in "../input/day4.txt".lines:
    let words = line.splitWhitespace

    if words.len == words.deduplicate.len:
        inc valid

    let sortedWords = words.mapIt(it.sorted.join)
    if sortedWords.len == sortedWords.deduplicate.len:
        inc valid2

echo valid
echo valid2