#! /usr/bin/python3
import sys
from operator import itemgetter

count = 0
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        ranges = list(map(lambda r: list(map(int, r.split('-'))),
                          line.rstrip('\n').split(',')))
        ranges.sort(key=itemgetter(1), reverse=True)
        ranges.sort(key=itemgetter(0))
        if ranges[1][1] <= ranges[0][1]:
            count += 1
print(count)
