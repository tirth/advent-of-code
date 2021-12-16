import strutils, sequtils, math

var versionSum = 0

let packetBin = "../input/day16.txt".readFile.mapIt(($it).parseHexInt.toBin(4)).join

proc parsePacket(offset: int): tuple[value, offset: int] =
    result.offset = offset

    let version = packetBin[result.offset .. result.offset+2].parseBinInt
    result.offset += 3

    versionSum += version

    let typeId = packetBin[result.offset .. result.offset+2].parseBinInt
    result.offset += 3

    if typeId == 4:
        var literalBin = ""

        while true:
            let hasMore = packetBin[result.offset] == '1'
            literalBin &= packetBin[result.offset+1 .. result.offset+4]
            result.offset += 5
            if not hasMore:
                break

        return (literalBin.parseBinInt, result.offset)

    var values: seq[int]

    case packetBin[result.offset]
    of '0':
        inc result.offset

        let length = packetBin[result.offset .. result.offset+14].parseBinInt
        result.offset += 15

        let until = result.offset + length

        while result.offset < until:
            let (value, offset) = parsePacket(result.offset)
            values.add(value)
            result.offset = offset
    of '1':
        inc result.offset

        let num = packetBin[result.offset .. result.offset+10].parseBinInt
        result.offset += 11

        for _ in 1..num:
            let (value, offset) = parsePacket(result.offset)
            values.add(value)
            result.offset = offset
    else:
        discard

    case typeId
    of 0: result.value = values.sum
    of 1: result.value = values.prod
    of 2: result.value = values.min
    of 3: result.value = values.max
    of 5: result.value = if values[0] > values[1]: 1 else: 0
    of 6: result.value = if values[0] < values[1]: 1 else: 0
    of 7: result.value = if values[0] == values[1]: 1 else: 0
    else: discard

let val = parsePacket(0).value

echo versionSum
echo val
