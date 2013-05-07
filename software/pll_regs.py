#!/usr/bin/python

import sys
import re

expr = re.compile("^\"([0-9a-fA-F]{4})\"\,\"[0-1]{8}\"\,\"([0-9a-fA-F]{2})\"", re.DOTALL)

lines = open(sys.argv[1],"r").readlines()


for l in lines:
    m = re.match(expr, l)
    if(m):
	print("{0x%s, 0x%s}," % (m.groups(1)[0], (m.groups(1)[1])))

print("{-1, -1}");