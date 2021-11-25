from parseutils import parseInt
import json, tables

proc sumNumbers(input: string): int = 
    var i = 0

    var parsed: int
    while i < input.len:    
        let numParsed = input.parseInt(parsed, i)
        if numParsed != 0:
            result += parsed
            i += numParsed
        else:
            i += 1

proc sumJson(node: JsonNode, skipRed: bool): BiggestInt = 
    case node.kind:
    of JInt:
        result += node.num
    of JArray:
        for elem in node.elems:
            result += sumJson(elem, skipRed)
    of JObject:
        if skipRed:
            for val in node.fields.values:
                if val.kind == JString and val.str == "red":
                    return

        for key, val in node.fields.pairs:
            result += sumJson(val, skipRed)
    of JBool: discard
    of JString: discard
    of JFloat: discard
    of JNull: discard

let input = "input/day12.txt".readFile

# echo sumNumbers(input)

let jsonRoot = parseJson(input)

echo sumJson(jsonRoot, false)
echo sumJson(jsonRoot, true)