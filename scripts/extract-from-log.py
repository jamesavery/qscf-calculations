#!/usr/bin/env python
from __future__ import with_statement;
import os;
from sys import argv;
from scanf import sscanf;

[log,outdir] = argv[1:];

with open(log,'r') as f:
    lines = f.readlines();
    splitpoints = [i for i in range(len(lines))
                   if lines[i].startswith("Calculating ")];

    for i in splitpoints:
        (jobid,inp) = sscanf(lines[i],"Calculating %s/%s");
        print (jobid,inp);


