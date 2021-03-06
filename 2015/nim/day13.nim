import algorithm, sequtils, strscans

type
    Pref = tuple[person: string, neighbour: string, happiness: int]

proc parsePreference(input: string): Pref = 
    let (success, person, change, happiness, neighbour) = scanTuple(input, "$w would $w $i happiness units by sitting next to $w.")
    if not success:
        raise newException(Exception, "parsing error")
    
    return (person, neighbour, (if change == "lose": -happiness else: happiness))

proc calcHappiness(guests: seq[string], prefs: seq[Pref]): int =
    for i in 0 ..< len(guests):
        var prev = i - 1
        if prev < 0:
            prev = len(guests) - 1

        let next = (i + 1) mod len(guests)

        let prevHappy = prefs.filterIt(it.person == guests[i] and it.neighbour == guests[prev])[0].happiness
        let nextHappy = prefs.filterIt(it.person == guests[i] and it.neighbour == guests[next])[0].happiness

        result += (prevHappy + nextHappy)

proc calcMaxHappiness(guests: var seq[string], prefs: seq[Pref]): int =
    guests.sort()

    result = calcHappiness(guests, prefs)
    while guests.nextPermutation:
        result = max(result, calcHappiness(guests, prefs))

var preferences: seq[Pref]
for line in "../input/day13.txt".lines:
    preferences.add(parsePreference(line))

var guests = preferences.mapIt(it.person).deduplicate
echo calcMaxHappiness(guests, preferences)

const me = "Me"

for guest in guests:
    preferences.add((guest, me, 0))
    preferences.add((me, guest, 0))

guests.add(me)
echo calcMaxHappiness(guests, preferences)