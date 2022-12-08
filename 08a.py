#! /usr/bin/python3
import sys

grid = []
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        grid += [list(map(int, line.rstrip('\n')))]

visible = 2 * (len(grid) + len(grid[0])) - 4
for y in range(1, len(grid) - 1):
    for x in range(1, len(grid[y]) - 1):
        def inner():
            global visible, y
            for direction in (0, 1), (0, -1), (1, 0), (-1, 0):
                is_visible = 1
                i, j = x, y
                dx, dy = direction
                while i > 0 and j > 0 \
                      and j < len(grid) - 1 and i < len(grid[y]) - 1:
                    i += dx
                    j += dy
                    if grid[j][i] >= grid[y][x]:
                        is_visible = 0
                visible += is_visible
                if is_visible:
                    return
        inner()
print(visible)
