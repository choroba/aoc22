#! /usr/bin/python3
import sys

grid = []
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        grid += [list(map(int, line.rstrip('\n')))]

best = 0
for y in range(0, len(grid)):
    for x in range(0, len(grid[y])):
        distances = []
        for direction in (0, 1), (0, -1), (1, 0), (-1, 0):
            distances.append(0)
            i, j = x, y
            dx, dy = direction
            while True:
                i += dx
                j += dy
                if i < 0 or j < 0 or j >= len(grid) or i >= len(grid[y]):
                    break

                distances[-1] += 1
                if grid[j][i] >= grid[y][x]:
                    break

        distance = distances[0]
        for d in  distances[1:4]:
            distance *= d
        if best < distance:
            best = distance
print(best)
