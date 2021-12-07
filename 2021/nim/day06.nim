import strutils, sequtils, math

type
    FishPop = array[9, int]

# circular shift register
proc getFishCounts(fishCounts: FishPop, day: int): FishPop =
    result = fishCounts
    for d in 0 ..< day:
        result[(d + 7) mod 9] += result[d mod 9]

proc getFishCountsRe(fishCounts: FishPop, day: int): FishPop =
    result = fishCounts
    
    for d in 0 ..< day:
        var newFish: FishPop

        newFish[8] = result[0] # new fish
        newFish[6] = result[0] # reset fish

        for i in 1..8:
            newFish[i - 1] += result[i] # reduce all timers

        for i in 0..8:
            result[i] = newFish[i] # update population

let nums = "../input/day6.txt".readFile.split(',').map(parseInt)

var fishCounts: FishPop
for n in nums:
    inc fishCounts[n]

echo fishCounts.getFishCounts(80).sum
echo fishCounts.getFishCounts(256).sum