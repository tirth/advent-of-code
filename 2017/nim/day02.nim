import strutils, sequtils, itertools

var checksum, checksum2 = 0

for line in "../input/day2.txt".lines:
    let vals = line.splitWhitespace.map(parseInt)
    checksum += vals.max - vals.min

    for twos in vals.combinations(2):
        let n = twos.max
        let d = twos.min
        if n mod d == 0:
            checksum2 += n div d

echo checksum
echo checksum2