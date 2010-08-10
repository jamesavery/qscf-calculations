#!/usr/bin/env python
from __future__ import with_statement;
from os import path, listdir;
from sys import argv, stderr;
from modules.convert import *;
from modules.scanf   import sscanf;

Hartrees = 27.21138386;

def firefly_energy(F):
        lines = F.readlines();
        converged = [l for l in lines if l.lstrip().startswith("DENSITY CONVERGED")]
        unconverged = [l for l in lines if l.lstrip().startswith("SCF IS UNCONVERGED")]

        if len(converged) != 1:
            if len(unconverged) != 1:
                print >> stderr, "Output file incomplete: no convergence statement.";
                raise ValueError;
            print >> stderr, unconverged[0];
            converged = False;
        else:
            converged = True;
            
        energyline = [float(l.split('=')[1]) for l in lines
                      if l.lstrip().startswith("TOTAL ENERGY")];
        
        if(len(energyline)!=1):
            print >> stderr, "No total energy found in %s!" % filename;
            raise ValueError;
        else:
            return (converged,energyline[0]*Hartrees);

def gaussian_energy(F):
        lines = F.readlines();
        elines = [l.strip() for l in lines if l.lstrip().startswith('SCF Done:') ];
        if elines == []:
            print >> stderr, "%s did not converge. Getting Erem." % filename;
            elines = [l.lstrip() for l in lines if l.lstrip().startswith("Matrix for removal")];
            if elines == []:
                print >> stderr, "Can't find Erem-energy!";
                raise ValueError;
            else:
                [iteration,energy] = sscanf(elines[-1],"Matrix for removal %d Erem= %f");
                converged = False;
        else:
            energy = float(elines[0].split('=')[1].lstrip().split()[0]);
            converged = True;
                
        return (converged,energy*Hartrees);


def ATK_energy(F):
    lines = F.readlines();
    converged = (len([l for l in lines if l.startswith("| Calculation Converged")])==1);
    elines    = [l for l in lines if l.startswith("| Total energy")];

    if not converged:
        unconverged = [l for l in lines if "did not converge" in l];
        if len(unconverged) != 1:
            print >> stderr, "Output file incomplete: no convergence statement.";
            raise ValueError;
        print >> stderr, unconverged[0];

    [energy] = sscanf(elines[0],"| Total energy = %f eV");

    return (converged,energy);          # Energy is already in eV.

energy_fn = {
    'Gaussian':gaussian_energy,
    'Firefly':firefly_energy,
    'ATK': ATK_energy
};

def collect_molecule(program,molecule):
    energies = {};
    for functional in [d for d in listdir(molecule) if not d.endswith(".sh")]:
        energy_f = {};    
        for basis in listdir(molecule+"/"+functional):
            jobpath = molecule+"/"+functional+"/"+basis;
            charges = listdir(jobpath);
            
            energy_b = {};
            converged_b = {};
            
            for q in charges:
                outpath = jobpath+"/"+q+"/output.log";
                print >> stderr, outpath;
                try:
                    with open(outpath,'r') as stream:
                        (converged,energy)    = energy_fn[program](stream);

                    energy_b[float(q)]    = energy;
                    converged_b[float(q)] = converged;
                except IOError:
                    print >> stderr, "Cannot read %s!" % outpath;
                except ValueError:
                    print >> stderr, "Error in %s!" % outpath;
                    
            if energy_b != {}:
                qs = sorted([(float(k),k) for k in energy_b.keys()]);
                e = {};
                e["q"]         = [q for (q,k) in qs];
                e["energy"]    = [energy_b[k] for (q,k) in qs];
                e["converged"] = [converged_b[k] for (q,k) in qs];
                energy_f[basis] = e;
                
                if energy_f != {}:
                    energies[functional] = energy_f;

    return energies;
