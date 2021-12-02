proc lookAndSay(input: string): string =
    var prev, current: char
    var idx, runLength = 1

    prev = input[0]
    while idx < input.len:
        current = input[idx]

        if current == prev:
            inc runLength
        else:
            result = result & $runLength & $prev
            prev = current
            runLength = 1

        inc idx

    result = result & $runLength & $prev

var input = "1113222113"
for i in 1..50:
    input = lookAndSay(input)

    if i == 40:
        echo input.len

echo input.len