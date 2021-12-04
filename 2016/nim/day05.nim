import strutils, strformat, md5, sequtils, terminal

const prefix = "00000"
const salt = "cxdnnyjw"

proc findHash(startIdx: var int): string = 
    for i in startIdx..100_000_000:
        let hash = getMD5(fmt"{salt}{i}")
        if hash[0 .. prefix.high] == prefix:
            startIdx = i + 1
            return hash

var pass: string
var fancyPass = "00000000"
var gotFancy = fancyPass.mapIt(false)
var idx, fancyIdx = 0

while pass.len < 8:
    pass.add findHash(idx)[5]

echo pass

echo fancyPass
while gotFancy.anyIt(it == false):
    let hash = findHash(fancyIdx)
    let posChr = hash[5]
    
    if not posChr.isDigit:
        continue

    let pos = ($posChr).parseInt
    if pos > 7 or gotFancy[pos]:
        continue

    cursorUp 1
    eraseLine
    echo fancyPass

    fancyPass[pos] = hash[6]
    gotFancy[pos] = true

cursorUp 1
eraseLine
echo fancyPass
