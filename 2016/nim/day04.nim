import sequtils, strutils, tables, algorithm

type
    Room = tuple[name: string, id: int, valid: bool]

const id_length = 3
const z_code = int('z')

proc parseRoom(input: string): Room =
    let dashIdx = input.rfind('-')

    let name = input[0 ..< dashIdx]
    let id = input[dashIdx + 1 .. dashIdx + id_length].parseInt
    let checksum = input[dashIdx + id_length + 2 ..< input.high]

    let check = newCountTable(name.replace("-", ""))
        .pairs
        .toSeq
        .sortedByIt((-it[1], it[0]))[0..4]
        .mapIt(it[0])
        .join

    (name, id, checksum == check)

proc rotateLetter(letter: char, amount: int): char =
    var l = int(letter) + (amount mod 26)
    if l > z_code:
        l = l - 26

    char(l)

proc decryptName(room: Room): string =
    for letter in room.name:
        result = result & (if letter == '-': ' ' else: letter.rotateLetter(room.id))

var sectorIdSum = 0
for line in "../input/day4.txt".lines:
    let room = parseRoom(line)
    if room.valid:
        sectorIdSum += room.id
        let realName = room.decryptName
        if "north" in realName:
            echo room.id

echo sectorIdSum
