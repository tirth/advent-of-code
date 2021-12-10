import strutils, sequtils, deques, tables, algorithm

const opening = "([{<"
const closing = ")]}>"

let invalidPoints = closing.zip([3, 57, 1197, 25137]).toTable
let closingPoints = closing.zip([1, 2, 3, 4]).toTable

var points = 0
var closeScores: seq[int]

for line in "../input/day10.txt".lines:
    var 
        stack: Deque[int]
        isValid = true

    for v in line:
        if v in opening:
            stack.addFirst(opening.find(v))
        else:
            if closing.find(v) != stack.popFirst:
                isValid = false
                points += invalidPoints[v]
                break

    if isValid:
        var closeScore = 0
        while stack.len > 0:
            closeScore = closeScore * 5 + closingPoints[closing[stack.popFirst]]

        closeScores.insert(closeScore, closeScores.lowerBound(closeScore))


echo points
echo closeScores[closeScores.len div 2]
