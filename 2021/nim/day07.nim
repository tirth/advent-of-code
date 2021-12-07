import strutils, sequtils, stats

proc toDist(nums: seq[int], toDist: int, increasing: bool = false): int =
    for num in nums:
        let dist = (num - toDist).abs

        if not increasing:
            result += dist
        else:
            result += (dist * (dist + 1)) div 2 # triangular numbers

let nums = "../input/day7.txt".readFile.split(',').map(parseInt)

var min, min2 = int.high
for i in 0..nums.mean.toInt:
    let gas = nums.toDist(i)
    if gas < min:
        min = gas

    let gas2 = nums.toDist(i, true)
    if gas2 < min2:
        min2 = gas2

echo min
echo min2