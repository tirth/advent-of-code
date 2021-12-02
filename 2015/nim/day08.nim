import strutils

var total1, total2 = 0
for line in "../input/day8.txt".lines:
    total1 += len(line) - len(unescape(line))
    total2 += len(escape(line)) - len(line)

echo total1
echo total2