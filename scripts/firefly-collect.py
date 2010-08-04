#!/usr/bin/env python
from __future__ import with_statement;
from os import path, listdir;
from sys import argv, stderr;
from modules.convert import *;

[molecule] = argv[1:];

energies = {};

for functional in listdir(molecule):
    energy_f = {};    
    for basis in listdir(molecule+"/"+functional):
        jobpath = molecule+"/"+functional+"/"+basis;
        charges = listdir(jobpath);

        energy_b = {};
        
        for q in charges:
            outpath = jobpath+"/"+q+"/output.log";
            try:
                with open(outpath) as output:
                    energyline = [float(l.split('=')[1]) for l in output.readlines()
                                  if l.lstrip().startswith("TOTAL ENERGY")];
                    if(len(energyline)<1):
                        print >> stderr, "No total energy found in %s!" % outpath;
                    else:
                        energy_b[float(q)] = energyline[0];
            except IOError:
                print >> stderr, "Cannot read %s!" % outpath;

        if energy_b != {}:
            qs = sorted([(float(k),k) for k in energy_b.keys()]);
            e = {};
            e["q"] = [q for (q,k) in qs];
            e["energy"] = [energy_b[k] for (q,k) in qs];
            energy_f[basis] = e;

    if energy_f != {}:
        energies[functional] = energy_f;

print "results = %s;\n" % mathematica_repr(energies);
