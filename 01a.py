#!/usr/bin/python3
import sys

max = 0
with open(sys.argv[1], 'r') as fh:
    sum = 0
    for line in fh:
        if len(line) > 1:
            sum += int(line.rstrip('\n'))
        else:
            if sum > max:
                max = sum
            sum = 0
print(max)
