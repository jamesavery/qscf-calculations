#!/usr/bin/env python
from mesh import *;
from subprocess import call;
import sys;

nm = 18.897259886;		# 1 nm in Bohrs
AA = 1.8897259886;		# 1AA in Bohrs

[boxW,boxH,boxD,vacuumW,vacuumH,oxideH,electrodeH] = [ float(p)*AA for p in sys.argv[1:] ];

electrodeW = (boxW-vacuumW)/2.0;
oxideH = boxH-vacuumH;

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

Physical Volume("Left electrode") = {6, 5, 4, 7, 8, 9};
Physical Volume("Vacuum") = {15, 14, 13, 16, 17, 18};
Physical Volume("Right electrode") = {24, 23, 22, 27, 26, 25};
Physical Volume("Gate oxide") = {3, 2, 1, 12, 11, 10, 21, 20, 19};

Physical Surface("Open boundaries") = {96, 102, 108, 106, 88, 70, 16, 124, 14, 8, 2, 3, 57, 111, 113, 119, 125, 93, 75};
Physical Surface("Left electrode boundary") = {42, 48, 54, 38, 39, 21, 20, 26, 32, 44, 50, 34, 52};
Physical Surface("Right electrode boundary") = {160, 142, 162, 156, 150, 147, 129, 155, 161, 149, 131, 137, 143};
Physical Surface("Gate electrode boundary") = {13, 7, 1, 67, 61, 55, 109, 115, 121};

""" %(boxW,boxH,boxD,vacuumW,vacuumH,oxideH,electrodeW,electrodeH,boxes);




