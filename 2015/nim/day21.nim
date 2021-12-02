import strutils, sequtils

type
    CharStats = tuple[hitPoints, damage, armour: int]
    ItemStats = tuple[name: string, cost, damage, armour: int]

const item_sep_idx = 11

proc parseItem(item: string): ItemStats =
    let name = item[0..item_sep_idx].strip(false)
    let stats = item[item_sep_idx..item.high].splitWhitespace().map(parseInt)

    return (name, stats[0], stats[1], stats[2])

proc equip(person: CharStats, items: openarray[ItemStats]): tuple[equipped: CharStats, cost: int] =
    var equipped = person
    var cost = 0

    for item in items:
        equipped.damage += item.damage
        equipped.armour += item.armour
        cost += item.cost

    return (equipped, cost)

proc damage(attacker, defender: CharStats): int =
    return max(attacker.damage - defender.armour, 1)

proc battle(player, boss: CharStats, maxTurns: int = 1_000): bool =
    var playerB = player
    var bossB = boss

    for turn in 1..maxTurns:
        # echo turn, ": ", playerB.hitPoints, " vs. ", bossB.hitPoints

        if turn mod 2 == 1:
            bossB.hitPoints -= damage(playerB, bossB)
            if bossB.hitPoints <= 0:
                return true
        else:
            playerB.hitPoints -= damage(bossB, playerB)
            if playerB.hitPoints <= 0:
                return false

iterator choose[T](things: openArray[T], num: int): seq[T] =
    var chosen = newSeqOfCap[T](num)

    var idx = 0
    var idxs = newSeqOfCap[int](num)

    while true:
        if chosen.len == num:
            # subset ready, drop last item and move to next index
            yield chosen
            discard chosen.pop()
            idx = idxs.pop() + 1

        elif idx != things.len:
            # add item to subset and move to next index
            chosen.add(things[idx])
            idxs.add(idx)
            inc idx

        elif idxs.len > 0:
            # subset isn't full but we're at the end of the list
            discard chosen.pop()
            idx = idxs.pop() + 1

        else:
            break

# assemble shop items
var weapons, armour, rings: seq[ItemStats]

var section: string
for line in "../input/day21_shop.txt".lines:
    if line.isEmptyOrWhitespace:
        section = ""
        continue

    if ':' in line:
        section = line.split(':')[0]
        continue

    let item = parseItem(line)

    case section:
    of "Weapons":
        weapons.add(item)
    of "Armor":
        armour.add(item)
    of "Rings":
        rings.add(item)
    else:
        raise newException(Exception, "unknown section, " & section)

armour.add(("None", 0, 0, 0))

# get ring combinations up front
var ringSets: seq[tuple[ring1, ring2: ItemStats]]
for ringSet in choose(rings, 2):
    ringSets.add((ringSet[0], ringSet[1]))

var itemCombos: seq[seq[ItemStats]]
for weapon in weapons:
    for arm in armour:
        # no ring
        itemCombos.add(@[weapon, arm])

        # one ring
        for ring in rings:
            itemCombos.add(@[weapon, arm, ring])

        # two rings
        for (ring1, ring2) in ringSets:
            itemCombos.add(@[weapon, arm, ring1, ring2])

var minCostWin = int.high
var maxCostLoss = 0

var player: CharStats = (100, 0, 0)
var boss: CharStats = (104, 8, 1)

for itemCombo in itemCombos:
    var (equippedPlayer, cost) = player.equip(itemCombo)

    if equippedPlayer.battle(boss):
        minCostWin = min(minCostWin, cost)
    else:
        maxCostLoss = max(maxCostLoss, cost)

echo minCostWin
echo maxCostLoss