#!/usr/bin/env python

from experiments import *;
import os;

root = os.environ['OPV'];
molecules = os.listdir(root+"/results");

for m in molecules:
    dEs = os.listdir(root+"/results/"+m);
    print m+': '+str(dEs);

    for dE in dEs:
        outputs = os.listdir("%s/results/%s/%s" % (root,m,dE))
        print "\t"+str(outputs);

        for f in outputs:
            
