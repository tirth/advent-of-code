import sequtils, strscans, strutils, tables, parseutils

type
    Passport = Table[string, string]

let requiredKeys = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

proc isValid(passport: Passport): bool =
    for key in requiredKeys:
        if not passport.hasKey(key):
            return false

    return true

proc checkYear(val: string, minYear, maxYear: int): bool =
    let (success, year) = scanTuple(val, "$i")
    return success and year in minYear..maxYear

proc checkHeight(val: string): bool =
    let (success, heightVal, heightUnit) = scanTuple(val, "$i$w")
    if not success:
        return false

    case heightUnit:
    of "cm":
        if heightVal < 150 or heightVal > 193:
            return false

    of "in":
        if heightVal < 59 or heightVal > 76:
            return false

    return true

let hairColourVals = Digits + {'a' .. 'f'}

proc checkHairColour(val: string): bool =
    if val[0] != '#':
        return false

    for c in val[1..val.high]:
        if c notin hairColourVals:
            return false

    return true

let validEyeColours = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

proc checkEyeColour(val: string): bool =
    return validEyeColours.contains(val)

proc checkPid(val: string): bool =
    if val.len != 9:
        return false

    try:
        discard parseInt(val)    
        return true
    except ValueError:
        return false

proc isValidValid(passport: Passport): bool =
    for key in requiredKeys:
        if not passport.hasKey(key):
            return false

        let val = passport[key]

        case key:
        of "byr":
            if not checkYear(val, 1920, 2002):
                return false

        of "iyr":
            if not checkYear(val, 2010, 2020):
                return false

        of "eyr":
            if not checkYear(val, 2020, 2030):
                return false
            
        of "hgt":
            if not checkHeight(val):
                return false

        of "hcl":
            if not checkHairColour(val):
                return false

        of "ecl":
            if not checkEyeColour(val):
                return false

        of "pid":
            if not checkPid(val):
                return false

    return true

var passports: seq[Passport]

var currentData: Passport
for line in "../input/day4.txt".lines:
    if line.isEmptyOrWhitespace:
        passports.add(currentData)
        currentData.clear()
        continue

    for pair in line.splitWhitespace.mapIt(it.split(':')):
        currentData[pair[0]] = pair[1]

if currentData.len > 0:
    passports.add(currentData)

var numValid, numValidValid = 0
for passport in passports:
    if passport.isValid:
        inc numValid

    if passport.isValidValid:
        inc numValidValid

echo numValid
echo numValidValid