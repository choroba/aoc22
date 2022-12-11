#! /usr/bin/python3
import sys

TICKS = {'addx': 2,
         'noop': 1}

x, tick = 1, 1
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        instruction, param = (line.split() + [None])[:2]
        for i in range(0, TICKS[instruction]):
            pixel_x = (tick - 1) % 40;
            pixel_y = int(tick / 40)
            if 0 == pixel_x:
                print()
            print('#' if abs(x - pixel_x) <= 1 else '.', end="")
            tick += 1

        if 'addx' == instruction:
            x += int(param)
        elif 'noop' != instruction:
            raise Exception(f'Unknown instruction {instruction}')
print()
