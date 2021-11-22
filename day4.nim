from std/strformat import fmt
from std/md5 import getMD5

proc findHash(input: string, searchPrefix: string): int = 
    for i in 1..100_000_000:
        if getMD5(fmt"{input}{i}")[0 ..< searchPrefix.len] == searchPrefix:
            return i

echo findHash("iwrupvqb", "00000")
echo findHash("iwrupvqb", "000000")
