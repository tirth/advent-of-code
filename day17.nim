import math, strutils, sequtils, sugar

proc combinationsWhere(values: seq[int], useResult: proc(res: seq[int]): bool): seq[seq[int]] =
    let comboCount = 1 shl values.len
    
    for i in 1 ..< comboCount:
        var res: seq[int]

        for j in 0 .. values.len:
            if (i shr j) mod 2 != 0:
                res.add(values[j])

        if useResult(res):
            result.add(res)

let input = readFile("input/day17.txt").splitLines.map(parseInt)

let combos = combinationsWhere(input, res => res.sum == 150)
echo combos.len

let minContainers = combos.mapIt(len it).min
echo combos.countIt(it.len == minContainers)