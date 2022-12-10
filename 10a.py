#! /usr/bin/python3
import sys

TICKS = {'addx': 2,
         'noop': 1}

x, tick, strength = 1, 1, 0
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        instruction, param = (line.split() + [None])[:2]
        for i in range(0, TICKS[instruction]):
            if tick % 40 == 20:
                strength += x * tick
            tick += 1

        if 'addx' == instruction:
            x += int(param)
        elif 'noop' != instruction:
            raise f'Unknown instruction {instruction}'

print(strength)
