#! /usr/bin/python3
import sys
import warnings

LENGTH = 4

with open(sys.argv[1], 'r') as fh:
    for line in fh:
        pos = LENGTH
        while pos < len(line):
            s = set(line[pos - LENGTH:pos])
            if len(s) == LENGTH:
                print(pos)
                break
            pos += 1
        else:
            warnings.warn('NOT FOUND')
