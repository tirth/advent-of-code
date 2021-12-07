import strutils, sequtils, sets

proc redistMem(mem: var seq[int]) =
    let maxIdx = mem.maxIndex
    let redist = mem[maxIdx]
    mem[maxIdx] = 0

    for i in 1..redist:
        inc mem[(maxIdx + i) mod mem.len]

proc memRep(mem: seq[int]): string =
    mem.join(",")

var 
    mem = "../input/day6.txt".readFile.splitWhitespace.map(parseInt)
    seen: HashSet[string]
    redistCount = 0
    
while not (mem.memRep in seen):
    seen.incl(mem.memRep)

    mem.redistMem
    inc redistCount

echo redistCount

let wanted = mem.memRep

redistCount = 0
while mem.memRep != wanted or redistCount == 0:
    mem.redistMem
    inc redistCount

echo redistCount