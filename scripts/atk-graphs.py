#!/usr/bin/env nlpython

from NanoLanguage import *;
from numpy import array;
import sys;

config = {};
with open("config/"+sys.argv[1]+".cfg","r") as cfg:
    lines = cfg.readlines();
    for l in lines:
        [key,val] = l.split('=')[0:2];
        config[key.strip()] = val.strip();


def mathlist(pylist):           # Takes 1D list
    return "{"+(",".join(map(mathpair,pylist)))+"}";
   
def mathpair((x,y)):
    return "{%f,%.16f}"%(x,y);

def zip(a,b):
    return [(a[i],b[i]) for i in range(len(a))];

ncname = config["output_directory"]+'/'+config["job_name"]+'.nc';

print "Loading from %s\n" % ncname;

vEff     = nlread(ncname, ElectrostaticDifferencePotential)[-1];
deltarho = nlread(ncname, ElectronDifferenceDensity)[-1];

dim = vEff.shape()[0];
mid = dim/2+1;
l   = float(config["line_length"]);
xs = [i*l/float(dim) for i in range(dim)];

vEffSection     = zip(xs,array(vEff[mid,mid,:][0,0]));
deltarhoSection = zip(xs,array(deltarho[mid,mid,:][0,0]));

with open(ncname.replace(".nc","-atk.m"),"w") as mathout:
    print >> mathout, "avEff     = %s;\n" % mathlist(vEffSection);
    print >> mathout, "adeltarho = %s;\n" % mathlist(deltarhoSection);

