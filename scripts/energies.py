#!/usr/bin/env python
from __future__ import with_statement;
from modules.experiments import *;
from modules.convert import *;
from modules.collect  import *;
from modules.scanf import sscanf;
from os import environ, path;
from sys import argv,stdout,stderr;
from string import split, join, strip;
from math import ceil;
import re;

files = [path.abspath(f) for f in argv[1:]];
root = environ['OPV'];

Hartrees = 27.21138386;                 # 1 Hartree in eV

def unique(l):
    s = list(frozenset(l));
    if(len(s)>1):
        raise ValueError("Multiple unique values in list.");
    return s[0];

def parsepath(f):
    if(path.abspath(argv[0]).startswith(root)):
        [molecule,exp1de,exp2] = f.split('/')[-3:];
    else:
        [molecule,exp1de,jobid,exp2] = f.split('/')[-4:];
    
    print >> stderr, [molecule,exp1de,jobid,exp2];
    [exp1,final_dE] = exp1de.rsplit('-',1);
    exp2 = exp2.split('.')[0];

    return (molecule, exp1, exp2, final_dE);

def fileparameters(f):
    base = path.splitext(path.basename(f))[0];
    m = re.search("([^\.]+)\.(.+)",base);
    return [float(p) for p in split(m.group(2),':')];
                 
def totalenergy(f):
    f = path.splitext(f)[0]+".out";
    try:
        return output_energy(string_matches["qscf"],f);
    except IOError:
        print >> stderr, "Cannot read %s!" % f;
        return (False,float('nan'));
    except ValueError:
        print >> stderr, "Error in %s!" % f;
        return (False,float('nan'));
    
def homolumoenergy(f):
    f = path.splitext(f)[0]+".err";
    with open(f,'r') as file:
        lines  = file.readlines();
        try:
            eline = [i for i in range(len(lines)) if lines[i].startswith("Energies")][-1];
        except IndexError:
            return (0,0,0);
        
        energies = split(lines[eline+1],' ');
        tup = lines[eline-1].split('= ')[1];
        print >> stderr, tup;
        (T,degeneracy,numberElectrons) = sscanf(tup,"(%f,%d,%f)");

        N = int(ceil(numberElectrons)-1)/degeneracy;
        return (float(energies[N])*Hartrees,
                float(energies[N+1])*Hartrees,
                numberElectrons);

def getinfo(f):
    finfo = parsepath(f);
    expt  = experiments[finfo[1]][finfo[2]];
    params = zip(expt['order'],fileparameters(f));
    (converged,energy) = totalenergy(f);
    (EH,EL,Nel) = homolumoenergy(f);

    return {
        'converged':converged,
        'energy':energy,
        'homo':EH,
        'lumo':EL,
        'params':params
        };


def mathematica_output(file,finfo,file_list):
    expt  = experiments[finfo[1]][finfo[2]];
    params   = [fileparameters(f) for f in file_list];
    ces      = [totalenergy(f)    for f in file_list];
    converged = [c for (c,e) in ces];
    energies  = [e for (c,e) in ces];
    HLN      = [homolumoenergy(f) for f in file_list];

    print >> file, "experiment = %s;\n"     % mathematica_list(finfo);
    print >> file, "parameterOrder = %s;\n" % mathematica_list(expt['order']);
    print >> file, "valueOrder = %s;\n"     % mathematica_list(['Total energy',
                                                                ['HOMO energy','LUMO energy',
                                                                 'Number of electrons'],'Converged']);

    propertylist = [(params[i],energies[i],HLN[i],converged[i]) for i in range(len(file_list))];
    print >> file, "propertylist = %s;\n" % mathematica_list(propertylist,collapse=True);

def python_output(file,finfo,file_list):
    expt  = experiments[finfo[1]][finfo[2]];
    params   = [fileparameters(f) for f in file_list];
    ces      = [totalenergy(f)    for f in file_list];
    converged = [c for (c,e) in ces];
    energies  = [e for (c,e) in ces];
    HLN      = [homolumoenergy(f) for f in file_list];

    print >> file, "experiment = %s;\n"     % repr(finfo);
    print >> file, "parameterOrder = %s;\n" % repr(expt['order']);
    print >> file, "valueOrder = %s;\n"     % repr(['Total energy',
                                                                ['HOMO energy','LUMO energy',
                                                                 'Number of electrons'],'Converged']);

    propertylist = [(params[i],energies[i],HLN[i],converged[i]) for i in range(len(file_list))];
    print >> file, "propertylist = %s;\n" % repr(propertylist);


 
try:
    finfo = unique([parsepath(f) for f in files]);
except ValueError:
    print >> stderr, "Only one experiment at a time for now.";
    print >> stderr, list(frozenset([parsepath(f) for f in files]));
    exit(-1);

if path.basename(argv[0]) == "energies-math.py":
    mathematica_output(stdout,finfo,files);
else:
    python_output(stdout,finfo,files);


