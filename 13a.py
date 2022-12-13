#! /usr/bin/python3
import sys
import re

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

def compare(packets):
    while not packets[1] is None and len(packets[1]):
        if not len(packets[0]):
            return 1

        p1 = packets[0].pop(0)
        p2 = packets[1].pop(0)

        if not type(p1) is list and not type(p2) is list:
            if p1 != p2:
                return 1 if p1 < p2 else 0

        elif not type(p1) is list or not type(p2) is list:
            packets[1].insert(0, p2 if type(p2) is list else [p2])
            packets[0].insert(0, p1 if type(p1) is list else [p1])

        else:
            comp = compare([p1, p2])
            if not comp is None:
                return comp
    if len(packets[0]):
        return 0

    return None

i = 0
total = 0
packets = [False, False]
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        if 1 == len(line):
            continue

        packets[1 if not packets[0] is False else 0] = parse(line)
        if not packets[1] is False:
            i += 1
            if compare(packets) == 1:
                total += i
            packets = [False, False]

print(total)
