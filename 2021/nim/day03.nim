import strutils, sequtils, tables

type
    BitList = seq[int]
    BitCount = CountTable[int]

proc toInt(bitList: BitList): int =
    bitList.join.parseBinInt

proc getCountsAt(nums: seq[BitList], index: int): BitCount =
    for num in nums:
        result.inc(num[index])

proc getCounts(nums: seq[BitList]): seq[BitCount] =
    let bitWidth = nums[0].len
    result.newSeq(bitWidth)

    for i in 0..<bitWidth:
        result[i] = nums.getCountsAt(i)

proc searchByCriteria(nums: seq[BitList], byMostCommon: bool = true): BitList =
    var searchNums = nums
    for i in 0..nums[0].high:
        let counts = searchNums.getCountsAt(i)

        let keep = if counts[0] > counts[1]: (if byMostCommon: 0 else: 1) else: (if byMostCommon: 1 else: 0)

        var kept: seq[BitList]
        for num in searchNums:
            if num[i] == keep:
                kept.add(num)

        searchNums = kept
        if searchNums.len == 1:
            break

    return searchNums[0]

let nums = "../input/day3.txt".readFile.splitLines.mapIt(it.mapIt(if it == '1': 1 else: 0))

let counts = nums.getCounts

var most, least: BitList
for c in counts:
    if c[0] > c[1]:
        most.add(0)
        least.add(1)
    else:
        most.add(1)
        least.add(0)

echo most.toInt * least.toInt

echo nums.searchByCriteria.toInt * nums.searchByCriteria(false).toInt
