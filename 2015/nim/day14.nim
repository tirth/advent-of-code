import strscans, sequtils, sugar, tables

type
    Reindeer = tuple[name: string, flySpeed: int, flyTime: int, restTime: int]

proc parseReindeer(input: string): Reindeer = 
    let (success, name, flySpeed, flyTime, restTime) = scanTuple(input, "$w can fly $i km/s for $i seconds, but then must rest for $i seconds")
    if not success:
        raise newException(Exception, "parsing error")
    
    return (name, flySpeed, flyTime, restTime)

proc getDistanceAt(seconds: int, reindeer: Reindeer): int =
    var flyLeft = reindeer.flyTime
    var restLeft = reindeer.restTime
    var flying = true

    for second in 1..seconds:
        if flying:
            result += reindeer.flySpeed
            dec flyLeft

            if flyLeft == 0:
                flying = false
                restLeft = reindeer.restTime
        else:
            dec restLeft

            if restLeft == 0:
                flying = true
                flyLeft = reindeer.flyTime

var reindeer: seq[Reindeer]

for line in "../input/day14.txt".lines:
    reindeer.add(parseReindeer(line))

const raceTime = 2503

echo reindeer.map(r => getDistanceAt(raceTime, r)).max

var scores = initCountTable[string]()

for second in 1..raceTime:
    var maxDist = 0
    var distances: Table[string, int]

    for r in reindeer:
        let dist = getDistanceAt(second, r)
        distances[r.name] = dist
        if dist > maxDist:
            maxDist = dist

    for r, dist in distances:
        if dist == maxDist:
            scores.inc(r)

echo scores.largest.val