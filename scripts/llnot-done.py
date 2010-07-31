#!/usr/bin/env python
from __future__ import with_statement;
import os;
from sys import argv;

[where,jobid] = argv[1:];

files = os.listdir(where);
outs   = [f for f in files if f.startswith(jobid) and f.endswith(".tar.gz")];
ins    = [f for f in files if f.startswith("qscf") and f.endswith(".out")];

inbase  = frozenset([f.split('.')[2] for f in ins]);
outbase = frozenset([f.split('.')[2] for f in outs]);

not_done = sort(list(inbase-outbase));

for j in not_done:
    print j;
