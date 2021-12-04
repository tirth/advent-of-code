import tables

var counts: seq[CountTable[char]]

for line in "../input/day6.txt".lines:
    if counts.len == 0:
        counts.newSeq(line.len)

    for i, c in line.pairs:
        counts[i].inc(c)

var str1, str2: string
for i in counts:
    str1.add i.largest.key
    str2.add i.smallest.key

echo str1
echo str2