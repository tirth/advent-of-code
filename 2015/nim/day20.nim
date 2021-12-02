proc getPresents(houseNum, stepSize: int, limit: int = int.high): int = 
    for n in 1..houseNum:
        if limit != int.high and houseNum > n * limit:
            continue

        if houseNum mod n == 0:
            result += n * stepSize

proc getPresentsRe(searchSize, stepSize: int, maxHouses: int = int.high): int =
    let maxElves = searchSize div stepSize
    var houses = newSeq[int](maxElves)

    for elfNum in 1..maxElves:
        for houseIdx in 1..min(maxElves div elfNum, maxHouses):
            houses[houseIdx * elfNum - 1] += elfNum * stepSize
        
        if houses[elfNum - 1] >= searchSize:
            return elfNum


const present_threshold = 34_000_000

echo getPresentsRe(present_threshold, 10)
echo getPresentsRe(present_threshold, 11, 50)

# for houseNum in 786_200..1_000_000:
#     if getPresents(houseNum, 10) >= present_threshold:
#         echo houseNum
#         break

# for houseNum in 831_550..1_000_000:
#     if getPresents(houseNum, 11, 50) >= present_threshold:
#         echo houseNum
#         break