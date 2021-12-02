import strscans, strutils

type
    Pass = tuple[minCount, maxCount: int, letter: char, password: string]

proc parsePass(input: string): Pass =
    let (success, minCount, maxCount, letter, password) = scanTuple(input, "$i-$i $c: $w")
    if not success:
        raise newException(Exception, "parsing error")
    
    return (minCount, maxCount, letter, password)

proc isValid(pass: Pass): bool =
    let numChar = pass.password.count(pass.letter)
    return numChar >= pass.minCount and numChar <= pass.maxCount

proc isValid2(pass: Pass): bool =
    let firstPos = pass.password[pass.minCount - 1] == pass.letter
    let secondPos = pass.password[pass.maxCount - 1] == pass.letter
    return firstPos xor secondPos

var numValid, numValid2 = 0
for line in "../input/day2.txt".lines:
    let pass = parsePass(line)

    if pass.isValid:
        inc numValid

    if pass.isValid2:
        inc numValid2

echo numValid
echo numValid2