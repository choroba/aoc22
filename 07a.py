#! /usr/bin/python3
import sys
import re

cwd = ['']
sizes = dict()
with open(sys.argv[1], 'r') as fh:
    for line in fh:
        if re.match('\$ cd \.\.$', line):
            if len(cwd) > 1:
                cwd.pop()
        elif re.match('\$ cd /$', line):
            cwd = ['']
        elif re.match('\$ cd .+$', line):
            dir = line.split()[2]
            cwd += [dir]
        elif not re.match('dir |\$ ls', line):
            size_s, name = line.split(maxsplit=2)
            size = int(size_s)
            for i in range(1, 1 + len(cwd)):
                path = '/'.join(cwd[0:i])
                if path in sizes:
                    sizes[path] += size
                else:
                    sizes[path] = size

sum = 0
for size in sizes.values():
    if size <= 100000:
        sum += size
print(sum)
