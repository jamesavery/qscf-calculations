#!/usr/bin/env python
from mesh import *;
from subprocess import call;
import sys;

nm = 18.897259886;		# 1 nm in Bohrs
AA = 1.8897259886;		# 1AA in Bohrs

[boxW,boxH,boxD] = [1600*AA,800*AA,800*AA];

electrodeW = boxW/2.0;

S = Space([boxW,boxH,boxD]);

S.addVolume(Volume([0,0,0],[electrodeW,boxH,boxD],"Left electrode"));
S.buildBoxes();

boxes = S.gmshBoxesAllpoints();

print """
// World box:        [%g,%g,%g]
// Electrode:         %g
divisions = 1;
%s

Physical Volume(1) = {1};                 // Electrode
Physical Volume(2) = {2};                 // Vacuum
Physical Surface(1) = {6, 4, 2, 1, 3};    // Electrode
Physical Surface(2) = {7, 10, 11, 12, 9}; // Vacuum


""" %(boxW,boxH,boxD,electrodeW,boxes);




