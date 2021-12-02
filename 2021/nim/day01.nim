import strutils, sequtils

# forward only iterative solution
var inc1, inc2, prev, prevSum: int
var window: seq[int]
for num in "../input/day1.txt".lines:
    let mes = num.parseInt

    if mes > prev and prev != 0:
        inc inc1

    prev = mes

    if window.len != 3:
        window.add(mes)

    if window.len == 3:
        let sum = window[0] + window[1] + window[2]
        if sum > prevSum and prevSum != 0:
            inc inc2

        prevSum = sum
        window = @[window[1], window[2], mes]

echo inc1
echo inc2

# in memory solution
let nums = "../input/day1.txt".readFile.splitLines.map(parseInt)

proc numIncreasing(nums: seq[int]): int =
    for i in 0..nums.high - 1:
        if nums[i] < nums[i + 1]:
            inc result    

echo nums.numIncreasing

var sums: seq[int]
for i in 0..nums.high - 2:
    sums.add(nums[i] + nums[i + 1] + nums[i + 2])

echo sums.numIncreasing