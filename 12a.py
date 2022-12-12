#! /usr/bin/python3
import sys

grid = []
x, y, tx, ty = [0] * 4

with open(sys.argv[1], 'r') as fh:
    for line in fh:
        line = line.rstrip('\n')
        if 'S' in line:
            y = len(grid)
            x = line.find('S')
            line = line.replace('S', 'a')
        if 'E' in line:
            ty = len(grid)
            tx = line.find('E')
            line = line.replace('E', 'z')
        grid += [list(map(lambda c: ord(c) - ord('a'), line))]

step = 0
current = {x: {y}}
seen = dict()
while not tx in current or not ty in current[tx]:
    nxt = dict()
    for X in current:
        for Y in current[X]:
            if not X in seen:
                seen[X] = set()
            seen[X].add(Y)
            for move in (0, 1), (1, 0), (0, -1), (-1, 0):
                nx = X + move[0]
                ny = Y + move[1]
                if nx < 0 or ny < 0 or ny >= len(grid) or nx >= len(grid[0]) \
                   or (nx in seen and ny in seen[nx]) \
                   or grid[ny][nx] - grid[Y][X] > 1:
                    continue
                if not nx in nxt:
                    nxt[nx] = set()
                nxt[nx].add(ny)
    step += 1
    current = nxt
print(step)
