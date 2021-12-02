from std/re import contains, re
from std/strutils import contains, count

const superNaughty = ["ab", "cd", "pq", "xy"]
const vowels = ['a', 'e', 'i', 'o', 'u']

proc isNice(input: string): bool = 
    for str in superNaughty:
        if input.contains(str):
            return false

    var vowelCount = 0
    for vowel in vowels:
        vowelCount += input.count(vowel)

    if vowelCount < 3:
        return false

    for letter in 'a' .. 'z':
        if input.contains(letter & letter):
            return true

let naughtyPairs = re"ab|cd|pq|xy"
let vowelMatch = re"(.*[aeiou]){3}"
let doubleLetter = re"(.)\1"

proc isNiceRe(input: string): bool =
    return not input.contains(naughtyPairs) and input.contains(vowelMatch) and input.contains(doubleLetter)

proc isNiceNew(input: string): bool = 
    var doublePair = false
    var infixLetter = false
    for l1 in 'a' .. 'z':
        for l2 in 'a' .. 'z':
            if input.count(l1 & l2) > 1:
                doublePair = true

            if input.contains(l1 & l2 & l1):
                infixLetter = true

            if doublePair and infixLetter:
                break
    
    return doublePair and infixLetter

let doublePair = re"(..).*\1"
let infixLetter = re"(.).\1"

proc isNiceNewRe(input: string): bool = 
    return input.contains(doublePair) and input.contains(infixLetter)

var niceCount, niceCountNew = 0
for line in "../input/day5.txt".lines:
    if isNiceRe(line):
        inc niceCount

    if isNiceNewRe(line):
        inc niceCountNew

echo niceCount
echo niceCountNew