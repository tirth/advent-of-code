import strutils, sequtils

let nums = "../input/day1.txt".readFile.splitLines.map(parseInt)

for i in 0..nums.high:
    for j in i + 1 .. nums.high:
        if nums[i] + nums[j] == 2020:
            echo nums[i] * nums[j]
            break

for i in 0..nums.high:
    for j in i + 1 .. nums.high:
        for k in j + 1 .. nums.high:
            if nums[i] + nums[j] + nums[k] == 2020:
                echo nums[i] * nums[j] * nums[k]
                break