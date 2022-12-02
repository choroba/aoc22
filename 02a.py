#! /usr/bin/python3
import sys

scores = {
    'ROCK'     : 1,
    'PAPER'    : 2,
    'SCISSORS' : 3,
    'LOST'     : 0,
    'DRAW'     : 3,
    'WON'      : 6
}

result = {
    'SCISSORS': {'PAPER'    : 'LOST',
                 'ROCK'     : 'WON'},
    'PAPER'   : {'ROCK'     : 'LOST',
                 'SCISSORS' : 'WON'},
    'ROCK'    : {'SCISSORS' : 'LOST',
                 'PAPER'    : 'WON'}
}
for shape in 'ROCK', 'PAPER', 'SCISSORS':
    result[shape][shape] = 'DRAW'

decode = {
    'A' : 'ROCK',
    'B' : 'PAPER',
    'C' : 'SCISSORS',
    'X' : 'ROCK',
    'Y' : 'PAPER',
    'Z' : 'SCISSORS'
}

score = 0
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        elf, me = line.split()
        score += scores[decode[me]] + scores[result[decode[elf]][decode[me]]]
print(score)
