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
        common = set(line)
        for i in (1, 2):
            following = next(fh, None)
            common = common.intersection(set(following))
        total += priority[list(common)[0]]
print(total)
