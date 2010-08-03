#!/usr/bin/env python
from __future__ import with_statement;
from modules.experiments import *;
from modules.convert import *;
from modules.scanf import sscanf;
from os import environ, path;
from sys import argv,stdout,stderr;
from string import split, join, strip;
import re;

files = [path.abspath(f) for f in argv[1:]];
root = environ['OPV'];

def unique(l):
    s = list(frozenset(l));
    if(len(s)>1):
        raise ValueError("Multiple unique values in list.");
    return s[0];

def parsepath(f):
    if(path.basename(argv[0]) == "energies.py"):
        [molecule,exp1de,exp2] = f.split('/')[-3:];
    else:
        [molecule,exp1de,jobid,exp2] = f.split('/')[-4:];
    
#    print [molecule,exp1de,exp2];
    [exp1,final_dE] = exp1de.split('-');
    exp2 = exp2.split('.')[0];

    return (molecule, exp1, exp2, final_dE);

def fileparameters(f):
    base = path.splitext(path.basename(f))[0];
    m = re.search("([^\.]+)\.(.+)",base);
    return [float(p) for p in split(m.group(2),':')];
                 
def totalenergy(f):
    f = path.splitext(f)[0]+".out";
    with open(f,'r') as file:
        eline = [l for l in file.readlines() if l.startswith("Total potential")][0];
        energy = sscanf(eline,"Total potential energy  = %f eV")[0];
        return energy;

def homolumoenergy(f):
    f = path.splitext(f)[0]+".err";
    with open(f,'r') as file:
        lines  = file.readlines();
        eline = [i for i in range(len(lines)) if lines[i].startswith("Energies")][-1];
        energies = split(lines[eline+1],' ');
        tup = lines[eline-1].split('= ')[1];
        (T,degeneracy,numberElectrons) = sscanf(tup,"(%f,%d,%d)");

        return (float(energies[(numberElectrons-1)/degeneracy]),
                float(energies[(numberElectrons-1)/degeneracy+1]),
                numberElectrons);

def getinfo(f):
    finfo = parsepath(f);
    expt  = experiments[finfo[1]][finfo[2]];
    params = zip(expt['order'],fileparameters(f));
    energy = totalenergy(f);
    (EH,EL,Nel) = homolumoenergy(f);

    return {
        'energy':energy,
        'homo':EH,
        'lumo':EL,
        'params':params
        };


def mathematica_output(file,finfo,file_list):
    expt  = experiments[finfo[1]][finfo[2]];
    params   = [fileparameters(f) for f in file_list];
    energies = [totalenergy(f)    for f in file_list];
    HLN      = [homolumoenergy(f) for f in file_list];

    print >> file, "order = %s;\n" % mathematica_list(expt['order']);

    propertylist = [(params[i],energies[i],HLN[i]) for i in range(len(file_list))];
    print >> file, "propertylist = %s;\n" % mathematica_list(propertylist,collapse=True);


 
try:
    finfo = unique([parsepath(f) for f in files]);
except ValueError:
    print >> stderr, "Only one experiment at a time for now.";
    exit(-1);

if argv[0] == "energies-math.py":
    mathematica_output(stdout,finfo,files);
else:
    print >> stderr, "More output formats to come.";
