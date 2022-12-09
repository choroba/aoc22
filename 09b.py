#! /usr/bin/python3
import sys

DIR = {'R': (1, 0),
       'L': (-1, 0),
       'U': (0, -1),
       'D': (0, 1)}

rope = list(map(lambda _x: [0, 0], range(0, 10)))
grid = {0: {0: 1}}
count = 1

with open(sys.argv[1], 'r') as fh:
    for line in fh:
        direction, length = line.split()
        for i in range(1, 1 + int(length)):
            rope[0][0] += DIR[direction][0]
            rope[0][1] += DIR[direction][1]

            for tail in range(1, 10):
                hx, hy, tx, ty = *rope[tail - 1], *rope[tail]
                dx = hx - tx
                dy = hy - ty
                if abs(dx) <= 1 and abs(dy) <= 1:
                    continue

                if dx:
                    tx += 1 if dx > 0 else -1
                if dy:
                    ty += 1 if dy > 0 else -1
                rope[tail] = [tx, ty]

            tx, ty = rope[9]
            if not tx in grid:
                grid[tx] = dict()
            if not ty in grid[tx]:
                count += 1
                grid[tx][ty] = 1
print(count)
