#!/usr/bin/env python
from __future__ import with_statement;
from os import path, listdir;
from sys import argv, stderr;
from modules.convert import *;
from modules.scanf   import sscanf;

Hartrees = 27.21138386;
eV       = 1.0;

def qscf_energy(l):
    [energy] = sscanf(l,"Total potential energy  = %f eV");
    return energy;

def firefly_energy(l):
    return float(l.split('=')[1]);

def gaussian_energy(l):
    return float(l.split('=')[1].lstrip().split()[0]);

def gaussian_unconverged_energy(l):
    [iteration,energy] = sscanf(l,"Matrix for removal %d Erem= %f");
    return energy;

def ATK_energy(l):
    [energy] = sscanf(l,"| Total energy = %f eV");
    return energy;


string_matches = {
    'qscf' : {
        'converged-match':       "Converged in",
        'unconverged-match':     "WARNING:  Did not converge",
        'energy-match':          "Total potential energy",
        'unit':                   eV,
        'get-energy':             qscf_energy,
        'get-unconverged-energy': qscf_energy
        },
    'Firefly':{
        'converged-match':        "DENSITY CONVERGED",
        'converged-match-2':      "ENERGY CONVERGED",
        'unconverged-match':      "SCF IS UNCONVERGED",
        'energy-match':           "TOTAL ENERGY",
        'unit':                   Hartrees,
        'get-energy':             firefly_energy,
        'get-unconverged-energy': firefly_energy
        },
    'Gaussian':{
        'converged-match':        "SCF Done:",
        # Doesn't ensure unconverged, but makes sure we have an unconverged energy
        'unconverged-match':      "Matrix for removal", 
        'energy-match':           "SCF Done",
        'unit':                   Hartrees,
        'get-energy':             gaussian_energy,
        'get-unconverged-energy': gaussian_unconverged_energy        
        },
    'ATK':{
        'converged-match':        "| Calculation Converged",
        'unconverged-match':      "# Warning: The calculation did not converge",
        'energy-match':           "| Total energy",
        'unit':                   eV,
        'get-energy':             ATK_energy,
        'get-unconverged-energy': ATK_energy        
        }
};

def output_energy(I,filename):
    with open(filename,'r') as F:
        lines = F.readlines();
        converged   = [l for l in lines if l.strip().startswith(I['converged-match']) or
					   ('converged-match-2' in I and l.strip().startswith(I['converged-match-2']))];
        unconverged = [l for l in lines if l.strip().startswith(I['unconverged-match'])];

        if len(converged) != 1:
            if len(unconverged) == 0:   # For Gaussian, we simply use Erem-lines, of which there are many!
                print >> stderr, "Output file incomplete: no convergence statement in %s." % filename;
                raise ValueError;
            print >> stderr, "%s: %s" % (filename,unconverged[0]);
            energyline = [I['get-unconverged-energy'](l) for l in lines if l.lstrip().startswith(I['energy-match'])];
            converged = False;
        else:
            energyline = [I['get-energy'](l) for l in lines if l.lstrip().startswith(I['energy-match'])];
            converged = True;

        if(len(energyline)!=1):
            print >> stderr, "No total energy found in %s!" % filename;
            raise ValueError;
        else:
            return (converged,energyline[0]*I['unit']);
        

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
                    (converged,energy)    = output_energy(string_matches[program],outpath);

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
