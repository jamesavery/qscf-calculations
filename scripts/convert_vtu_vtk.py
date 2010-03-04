#!/usr/bin/env python

import warnings;
warnings.filterwarnings('ignore');
from paraview.simple import *;
warnings.filterwarnings('always');

import sys;

if len(sys.argv) < 3:
    print >> sys.stderr, "Syntax: ./convert_vtu_vtk.py <vtufiles>";
    sys.exit(-1);


reader = servermanager.sources.XMLUnstructuredGridReader(FileNames=sys.argv[1:]);

for i in range(len(sys.argv)-1):
    outfile = sys.argv[i+1].replace(".vtu",".vtk");
    print "Attempting to write ",outfile;
    reader.UpdatePipeline(i);
    writer = servermanager.writers.LegacyVTKWriter(Input=reader, FileName=outfile);
    writer.UpdatePipeline();






