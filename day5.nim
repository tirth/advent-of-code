from strutils import contains, count

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

proc isNiceNew(input: string): bool = 
    var doublePair = false
    var infixLetter = false
    for l1 in 'a' .. 'z':
        for l2 in 'a' .. 'z':
            if input.count(l1 & l2) > 1:
                doublePair = true

            if input.contains(l1 & l2 & l1):
                infixLetter = true
    
    return doublePair and infixLetter

var niceCount, niceCountNew = 0
for line in "day5_input.txt".lines:
    if isNice(line):
        inc niceCount

    if isNiceNew(line):
        inc niceCountNew

echo niceCount
echo niceCountNew