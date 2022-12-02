#!/usr/bin/python3
import sys

maxes = [0, 0, 0]
with open(sys.argv[1], 'r') as fh:
    elf = 0
    for line in fh:
        if len(line) > 1:
            elf += int(line.rstrip('\n'))
        else:
            if elf > maxes[0]:
                maxes.append(elf)
                maxes.sort()
                maxes.pop(0)
            elf = 0
print(sum(maxes))
