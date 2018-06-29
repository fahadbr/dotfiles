#!/usr/bin/python

import sys

with open(sys.argv[1]) as colorscheme:
    for nextl in colorscheme.readlines():
        if "Color=" in nextl:
            regs = nextl.split("=")[1].split(",")
            hexs = [hex(int(i)).split('x')[-1] for i in regs]
            print("Color=" +"".join(hexs))
        else:
            print(nextl, end='')
