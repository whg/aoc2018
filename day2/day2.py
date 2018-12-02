import fileinput
from collections import Counter
from operator import mul, ne
from itertools import product

lines = list(map(lambda e: e.strip(), fileinput.input()))

counts = map(Counter, lines)
values = map(lambda e: set(e.values()), counts)
has_2_3 = map(lambda e: (2 in e, 3 in e), values)
sum_2_3 = map(sum, zip(*has_2_3))
print(mul(*sum_2_3))

for a, b in product(lines, lines):
    if sum(map(lambda e: ne(*e), zip(a, b))) == 1:
        same = map(lambda e: False if ne(*e) else e[0], zip(a, b))
        common = ''.join(filter(None, same))
        print(common)
        break
