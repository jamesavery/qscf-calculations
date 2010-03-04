#!/usr/bin/env python
import warnings;
warnings.filterwarnings('ignore');
from paraview.simple import *;
warnings.filterwarnings('always');

import sys;

if len(sys.argv) < 3:
    print >> sys.stderr, "Syntax: ./convert_vtk_vtu.py <vtkfiles>";
    sys.exit(-1);

reader = servermanager.sources.LegacyVTKReader(FileNames=sys.argv[1:]);

for i in range(len(sys.argv)-1):
    outfile = sys.argv[i+1].replace(".vtk",".vtu");
    print "Attempting to write ",outfile;
    reader.UpdatePipeline(i);
    writer = servermanager.writers.XMLUnstructuredGridWriter(Input=reader, DataMode=1,
                                                             FileName=outfile);
    writer.UpdatePipeline();





