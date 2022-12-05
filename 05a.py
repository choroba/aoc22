#! /usr/bin/python3
import sys
import re

stacks = []
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        if re.search(r'\d', line):
            break
        i = 0
        for c in line[1::4]:
            if i >= len(stacks):
                stacks.append([])
            if c != ' ':
                stacks[i].append(c)
            i += 1

    next(fh)
    for line in fh:
        quantity, source, target = map(int, re.findall(r'\d+', line))
        for i in range(0, quantity):
            stacks[target - 1].insert(0, stacks[source - 1].pop(0))

print("".join(map(lambda s:s[0], stacks)))
