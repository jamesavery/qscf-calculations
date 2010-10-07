#!/usr/bin/env python
from mesh import *;
from subprocess import call;
import sys;

nm = 18.897259886;		# 1 nm in Bohrs
AA = 1.8897259886;		# 1AA in Bohrs

[boxW,boxH,boxD,vacuumW,vacuumH,oxideH,electrodeH] = [ float(p)*AA for p in sys.argv[1:] ];

electrodeW = (boxW-vacuumW)/2.0;

S = Space([boxW,boxH,boxD]);

S.addVolume(Volume([0,oxideH,0],[electrodeW,electrodeH,boxD],"Left electrode"));
S.addVolume(Volume([electrodeW,oxideH,0],[vacuumW,vacuumH,boxD],"Vacuum"));
S.addVolume(Volume([electrodeW,oxideH,(boxD-vacuumW)/2],[vacuumW,vacuumW,vacuumW],"Vacuum around molecule"));
S.addVolume(Volume([electrodeW+vacuumW,oxideH,0],[electrodeW,electrodeH,boxD],"Right electrode"));
S.addVolume(Volume([0,0,0],[boxW,oxideH,boxD],"Gate oxide"));

S.buildBoxes();

boxes = S.gmshBoxesAllpoints();

#call(['cat','mesh-scripts/box.gmsh']);
print """
// World box:        [%g,%g,%g]
// Vacuum:           [%g,%g]
// Oxide height:     %g
// Electrode:        [%g,%g]
divisions = 1;
%s
Physical Volume("Left electrode") = {6, 9, 5, 8, 4, 7};
Physical Volume("Vacuum") = {12, 24, 36, 21, 18, 20, 23, 35, 11, 10, 22, 34, 19, 17, 16};
Physical Volume("Right electrode") = {30, 33, 29, 32, 28, 31};
Physical Volume("Gate oxide") = {1, 2, 3, 13, 14, 15, 25, 26, 27};

Physical Surface("Open boundaries") = {56, 60, 57, 129, 132, 204, 201, 203, 209, 215, 111, 93, 138, 210, 216, 72, 144, 66, 70, 142, 124, 214, 106, 62, 68,160, 88, 16, 14, 8, 2, 3, 75, 147, 149, 155, 161};
Physical Surface("Left electrode boundary") = {34, 52, 32, 26, 20, 21, 39, 38, 44, 50};
Physical Surface("Right electrode boundary") = {196, 178, 179, 197, 191, 173, 185, 167, 165, 183};
Physical Surface("Gate electrode boundary") = {1, 7, 13, 85, 79, 73, 145, 151, 157};

""" %(boxW,boxH,boxD,vacuumW,vacuumH,oxideH,electrodeW,electrodeH,boxes);




