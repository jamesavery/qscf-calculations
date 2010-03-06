#!/usr/bin/env python 
import warnings;
warnings.filterwarnings('ignore');
from paraview.simple import *;
warnings.filterwarnings('always');

import sys;
import math;
import os;
import fnmatch;

config = {};
with open("config/"+sys.argv[1]+".cfg","r") as cfg:
    lines = cfg.readlines();
    for l in lines:
        [key,val] = l.split('=')[0:2];
        config[key.strip()] = val.strip();

sourcenames = ["rho","deltarho","vEff","compensationcharge","corecharge",
               "xc","vzero","vEffAdjusted"];
arraynames = ["rho","deltarho","vEff","CompensationCharge","CoreCharge",
              "XC","Vzero","vEffAdjusted"];

X      = float(config["midpoint"]);
length = float(config["line_length"]);
axis   = int(config["line_axis"]);
resolution = int(config["resolution"]);
vtufiles = fnmatch.filter(os.listdir(config["output_directory"]),"deltarho-[0-9]*.vtu");
timesteps = len(vtufiles);


x0 = [X,X,X];
x1 = [X,X,X];
x0[axis] = 0;
x1[axis] = length;

line = Line(Point1=x0,Point2=x1,Resolution=resolution);


def zip(a,b):
    return [(a[i],b[i]) for i in range(len(a))];

def mathlist(pylist):           # Takes 1D list
    return "{"+(",".join(map(str,pylist)))+"}";
    
def mathpair(x,y):
    return "{%f,%.16f}"%(x,y);

def probeline(sourcename,name,x0,x1,resolution): 
    source = FindSource(sourcename);
    line = Line(Point1=x0,Point2=x1,Resolution=resolution);
    probe = servermanager.filters.ProbeLocation(Input=source,ProbeType=line);

    localsource = servermanager.Fetch(probe);
    valuearray  = localsource.GetPointData().GetArray(name);

    points = [localsource.GetPoint(i) for i in range(0,resolution)];

    xs = [p[axis] for p in points];
    ys = [valuearray.GetTuple1(i) for i in range(0,resolution)];

    return [xs,ys];

def readandprobeline(sourcename,name,line,resolution): 
    filenames = [config["output_directory"]+"/"+sourcename+"-"+str(i)+".vtu" 
                 for i in range(timesteps)];
    print "Attempting to read ",filenames;

    source = servermanager.sources.XMLUnstructuredGridReader(
        FileName=filenames
    );
    probe = servermanager.filters.ProbeLocation(Input=source,ProbeType=line);

    probe.UpdatePipeline(0);
    localsource = servermanager.Fetch(probe);
    points = [localsource.GetPoint(i) for i in range(0,resolution)];
    all_xs = [p[axis] for p in points];

    dataseries  = [];
    validpoints = [];
    for time in range(timesteps):
        print "Extracting time step ", time;

        probe.UpdatePipeline(time);

        localsource = servermanager.Fetch(probe);
        validarray  = localsource.GetPointData().GetArray("vtkValidPointMask");
        valuearray  = localsource.GetPointData().GetArray(name);

        valid = [validarray.GetValue(i) for i in range(resolution)];

        xs = [all_xs[i] for i in range(resolution) if valid[i]=="\x01"];
        ys = [valuearray.GetValue(i) for i in range(resolution) if valid[i]=="\x01"];

        dataseries.append([xs,ys]);

    return dataseries;



def seriestomath(series,name, file=sys.stdout):
    print >> file, "q"+name+" = "+mathlist([
            mathlist([mathpair(xs[i],ys[i]) for i in range(len(xs))])
            for [xs,ys] in series
            ])+";\n";


with open(config["output_directory"]+"/femoutput.m",'w') as file:
    for i in range(len(sourcenames)):
        series = readandprobeline(sourcenames[i],arraynames[i],line,resolution);
        seriestomath(series,arraynames[i],file);

