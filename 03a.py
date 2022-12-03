#!/usr/bin/python3
import sys

priority = dict([(chr(c), 1 + c - ord('a'))
                 for c in range(ord('a'), 1 + ord('z'))]
                + [(chr(c), 27 + c - ord('A'))
                   for c in range(ord('A'), 1 + ord('Z'))])

total = 0
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        line = line.rstrip('\n')
        length = len(line)
        compartment = set(line[0:length // 2])
        common = compartment.intersection(set(line[length // 2:]))
        total += priority[list(common)[0]]
print(total)
