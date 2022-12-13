#! /usr/bin/python3
import sys
import re
import copy
from functools import cmp_to_key

def _parse(tokens):
    struct = []
    while (tokens):
        if re.match(r'[0-9]', tokens[0]):
            struct += [int(tokens.pop(0))]

        elif '[' == tokens[0]:
            parsed, rest = _parse(tokens[1:])
            struct += [parsed]
            tokens = rest

        elif ']' == tokens[0]:
            return struct, tokens[1:]

        else:
            raise Exception(f"Can't parse {tokens[0]}")
    return struct[0]

def parse(packet):
    tokens = re.findall(r'([0-9]+|[\[\]])', line)
    return _parse(tokens)

def compare(*packets):
    while len(packets[1]) and not packets[1] is None:
        if not len(packets[0]):
            return 1

        p1 = packets[0].pop(0)
        p2 = packets[1].pop(0)

        if not type(p1) is list and not type(p2) is list:
            if p1 != p2:
                return 1 if p1 < p2 else -1

        elif not type(p1) is list or not type(p2) is list:
            packets[1].insert(0, p2 if type(p2) is list else [p2])
            packets[0].insert(0, p1 if type(p1) is list else [p1])

        else:
            comp = compare(p1, p2)
            if not comp is None:
                return comp
    if len(packets[0]):
        return -1

    return None

def sortcompare(*packets):
    return compare(copy.deepcopy(packets[1]), copy.deepcopy(packets[0]))

packets = [[[2]], [[6]]]
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        if 1 == len(line):
            continue

        packets += [parse(line)]

key = 1
packets = sorted(packets, key=cmp_to_key(sortcompare))
for i in range(0, len(packets)):
    if 1 == len(packets[i]) and type(packets[i][0]) is list \
       and 1 == len(packets[i][0]) and not type(packets[i][0][0]) is list \
       and packets[i][0][0] in (2, 6):
        key *= i + 1

print(key)
