#!/usr/bin/env python
import os;
from sys import argv;

def is_finished(f):
    with open(where+"/"+f,'r') as file:
        eline = [l for l in file.readlines() if l.startswith("Total pot")];
        return (len(eline)>0);

[where,expt] = argv[1:2];

files = os.listdir(where);
ins   = [f for f in files if f.startswith(expt) and f.endswith(".in")];
outs  = [f for f in files
         if f.startswith(expt) and f.endswith(".out") and is_finished(f)];

inbase  = frozenset([os.path.splitext(f)[0] for f in ins]);
outbase = frozenset([os.path.splitext(f)[0] for f in outs]);

done     = list(outbase);
not_done = list(inbase-outbase);

for j in not_done:
    print j;

