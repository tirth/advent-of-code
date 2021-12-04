import sequtils, strutils

proc checkAbba(run: string): bool =
    for i in 0..run.len - 4:
        if run[i] != run[i + 1] and run[i] == run[i + 3] and run[i + 1] == run[i + 2]:
            return true

proc findAbas(run: string): seq[string] =
    for i in 0..run.len - 3:
        if run[i] != run[i + 1] and run[i] == run[i + 2]:
            result.add(run[i..i + 2])

proc getRuns(line: string): tuple[outside, inside: seq[string]] =
    var idx = 0
    var outRun, inRun: string

    while idx < line.len:
        if line[idx] == '[':
            # outside run over, add to result and reset
            result.outside.add(outRun)
            outRun = ""

            # move to inside run
            inc idx
            while line[idx] != ']':
                inRun.add line[idx]
                inc idx

            # inside run over, add to result and reset
            result.inside.add(inRun)
            inRun = ""
            inc idx

        outRun.add line[idx]
        inc idx

    # add remaining outside run
    result.outside.add(outRun)

proc getRunsRe(line: string): tuple[outside, inside: seq[string]] =
    for i, run in line.replace('[', ']').split(']').toSeq.pairs:
        if i mod 2 == 0:
            result.outside.add(run)
        else:
            result.inside.add(run)

var hasTls, hasSsl = 0
for line in "../input/day7.txt".lines:
    let (outside, inside) = line.getRunsRe

    if outside.anyIt(it.checkAbba) and not inside.anyIt(it.checkAbba):
        inc hasTls

    block sslCheck:
        for o in outside:
            for aba in o.findAbas:
                let bab = aba[1] & aba[0] & aba[1]
                if inside.anyIt(bab in it):
                    inc hasSsl
                    break sslCheck

echo hasTls
echo hasSsl
