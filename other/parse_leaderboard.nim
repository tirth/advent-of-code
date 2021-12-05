import json, tables, options, algorithm, times, strutils, strformat, terminal, sequtils

const emptyDur = initDuration(0)
const highlight_name = "tirth"

type
    Info = tuple[name: string, time: Duration, part2Time: Duration]
    Completion = object
        get_star_ts: int
    Day = object
        `1`: Option[Completion]
        `2`: Option[Completion]
    User = object
        name: string
        stars: int
        completion_day_level: Table[string, Day]
        local_score: int
        global_score: int
    Leaderboard = object
        members: Table[string, User]
        event: string
        owner_id: string

proc formatDuration(duration: Duration): string =
    let parts = duration.toParts

    if parts[Days] != 0:
        result.add fmt"{parts[Days]}d:"
    
    if parts[Hours] != 0:
        result.add fmt"{parts[Hours]}h:"

    result.add fmt"{parts[Minutes]}m:{parts[Seconds]}s"

proc displayInfo(info: seq[Info], isPart2: bool = false, displayCount: int = 10) =
    var count = 0

    for i, t, p2t in info.sortedByIt(it.time).items:
        var info = fmt"{i:<20}"

        info.add fmt" {t.formatDuration}"

        if isPart2:
            info.add fmt" ({p2t.formatDuration})"

        if i == highlight_name:
            styledEcho styleBright, fgRed, info
        else:
            echo info

        inc count
        if count >= displayCount:
            break

proc getDayInfo(leaderboard: Leaderboard): Table[int, tuple[part1, part2: seq[Info]]] =
    for member, info in leaderboard.members:
        for day, dayInfo in info.completion_day_level:
            let dayNum = day.parseInt
            if dayNum notin result:
                result[dayNum] = (@[], @[])

            let start = dateTime(leaderboard.event.parseInt, mDec, dayNum).toTime

            let part1Info = info.completion_day_level[$day].`1`
            var part1Time: Time
            if part1Info.isSome:
                part1Time = part1Info.get.get_star_ts.fromUnix
                result[dayNum].part1.add((info.name, part1Time - start, emptyDur))

            let part2Info = info.completion_day_level[$day].`2`
            if part2Info.isSome:
                let part2Time = part2Info.get.get_star_ts.fromUnix
                result[dayNum].part2.add((info.name, part2Time - start, part2Time - part1Time))

let leaderboard = "private_leaderboard_2021.json".readFile.parseJson.to(Leaderboard)

let dayInfo = leaderboard.getDayInfo
for day in dayInfo.keys.toSeq.sortedByIt(it):
    let (part1, part2) = dayInfo[day]

    styledEcho styleDim, bgGreen, "Day ", $day

    styledEcho fgCyan, "Part 1"
    part1.displayInfo
    echo ""

    styledEcho fgCyan, "Part 2"
    part2.displayInfo(true)
    echo "========="