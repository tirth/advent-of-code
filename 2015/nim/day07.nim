from std/strutils import splitLines
from std/strscans import scanf
from std/parseutils import parseInt
import std/tables
import std/sets

var circuit: Table[string, uint16]

proc processInstruction(instruction: string) =
    var signal: int
    var inputA, inputB, destWire, op: string
    if scanf(instruction, "$i -> $w", signal, destWire):
        circuit[destWire] = uint16(signal)
    elif scanf(instruction, "$w -> $w", inputA, destWire):
        circuit[destWire] = circuit[inputA]
    elif scanf(instruction, "$w $w $w -> $w", inputA, op, inputB, destWire):
        let signalA = circuit[inputA]
        let signalB = circuit[inputB]
        case op:
        of "AND":
            circuit[destWire] = signalA and signalB
        of "OR":
            circuit[destWire] = signalA or signalB
    elif scanf(instruction, "$i AND $w -> $w", signal, inputA, destWire):
        circuit[destWire] = uint16(signal) and circuit[inputA]
    elif scanf(instruction, "$w $w $i -> $w", inputA, op, signal, destWire):
        let signalA = circuit[inputA]
        case op:
        of "LSHIFT":
            circuit[destWire] = signalA shl uint16(signal)
        of "RSHIFT":
            circuit[destWire] = signalA shr uint16(signal)
    elif scanf(instruction, "NOT $w -> $w", inputA, destWire):
        circuit[destWire] = not circuit[inputA]
    else:
        raise newException(Exception, "parsing error: " & instruction)

var current = -1;
var successful: HashSet[int]

var inst = readFile("../input/day7.txt").splitLines()
while successful.len != inst.len:
    inc current

    if current == inst.len:
        current = 0

    if current in successful:
        continue

    let currentInst = inst[current]
    try:
        processInstruction(currentInst)
        successful.incl(current)
    except KeyError:
        # echo getCurrentExceptionMsg()
        continue

# echo circuit
echo circuit["a"]

inst[3] = $circuit["a"] & " -> b"

circuit.clear()
current = -1
var successAgain: HashSet[int]

while successAgain.len != inst.len:
    inc current

    if current == inst.len:
        current = 0

    if current in successAgain:
        continue

    let currentInst = inst[current]
    try:
        processInstruction(currentInst)
        successAgain.incl(current)
    except KeyError:
        # echo getCurrentExceptionMsg()
        continue

# echo circuit
echo circuit["a"]
