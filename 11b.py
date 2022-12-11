#! /usr/bin/python3
import re
import sys

monkeys = []
product = 1
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        if re.match(r'Monkey [0-9]+:', line):
            monkeys += [{'active':0}]
        elif re.search(r'Starting items', line):
            s = re.search(r'([0-9][^\n]+)', line)
            monkeys[-1]['items'] = s.group(1).split(', ')
        elif re.search(r'Operation:', line):
            s = re.search(r'new = (.*)', line)
            monkeys[-1]['operation'] = s.group(1)
        elif re.search(r'Test:', line):
            s = re.search(r'by ([0-9]+)', line)
            t = int(s.group(1))
            monkeys[-1]['test'] = t
            product *= t
        elif re.search(r'throw to monkey', line):
            s = re.search(r'(true|false): throw to monkey ([0-9]+)', line)
            monkeys[-1][s.group(1)] = s.group(2)
        elif re.search(r'.', line):
            raise Exception(f'Can\'t parse {line}')

for round in range(1, 10001):
    for monkey in monkeys:
        while monkey['items']:
            monkey['active'] += 1
            item = monkey['items'].pop(0)
            expression = monkey['operation']
            v1, op, v2 = expression.replace('old', item).split()
            level = int(v1) + int(v2) if '+' == op else int(v1) * int(v2)
            to = monkey['true' if 0 == level % monkey['test'] else 'false']
            monkeys[int(to)]['items'] += [str(level % product)]

business = [0, 0]
for monkey in monkeys:
    if monkey['active'] >= business[0]:
        business += [monkey['active']]
        business.sort()
        business.pop(0)
print(business[0] * business[1])
