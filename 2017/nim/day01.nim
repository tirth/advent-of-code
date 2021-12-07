const digit_offset = int('0')

proc toInt(c: char): int =
    int(c) - digit_offset

let input = "../input/day1.txt".readFile

var matchSum, matchSum2 = 0
for i in 0..input.high:
    let current = input[i].toInt
    
    if current == input[(i + 1) mod input.len].toInt:
        matchSum += current

    if current == input[(i + input.len div 2) mod input.len].toInt:
        matchSum2 += current

echo matchSum
echo matchSum2