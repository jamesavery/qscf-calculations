#!/usr/bin/env python
from __future__ import with_statement;
from modules.experiments import *;
from os import environ, path;
from sys import argv;
from string import split, join, strip;
from modules.scanf import sscanf;

def parsepath(f):
    [molecule,exp1de,exp2] = f.split('/')[-3:];
#    print [molecule,exp1de,exp2];
    [exp1,final_dE] = exp1de.split('-');
    exp2 = exp2.split('.')[0];

    return (molecule, exp1, exp2, final_dE);

def fileparameters(f):
    base = path.basename(f);
    return [s for l in split(base,'.') for s in split(l,':') ][1:-1];
                 
def totalenergy(f):
    f = path.splitext(f)[0]+".out";
    with open(f,'r') as file:
        eline = [l for l in file.readlines() if l.startswith("Total potential")][0];
        energy = sscanf(eline,"Total potential energy  = %f eV")[0];
        return energy;

def homolumuenergy(f):
    f = path.splitext(f)[0]+".err";
    with open(f,'r') as file:
        lines  = file.readlines();
        eline = [i for i in range(len(lines)) if lines[i].startswith("Energies")][-1];
        energies = split(lines[eline+1],' ');
        tup = lines[eline-1].split('= ')[1];
        (T,degeneracy,numberElectrons) = sscanf(tup,"(%f,%d,%d)");

        return (energies[numberElectrons/degeneracy],
                energies[numberElectrons/degeneracy+1],
                numberElectrons);


def getinfo(files):
    finfo = parsepath(f);
    expt  = experiments[finfo[1]][finfo[2]];
    params = zip(expt['order'],fileparameters(f));
    energy = totalenergy(f);
    (EH,EL,Nel) = homolumuenergy(f);

    return {
        'energy':energy,
#        'homo':EH,
#        'lumo':EL,
        'params':params
        };

    
files = [path.abspath(f) for f in argv[1:]];
root = environ['OPV'];

expts = list(set([parsepath(f) for f in files]));
info = [getinfo(f) for f in files];

print expts;
for I in info:
    print I;

print [I['energy'] for I in info];
