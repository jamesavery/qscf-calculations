#!/usr/bin/env python
from mesh import *;
import sys;

nm = 18.897259886;		# 1 nm in Bohrs
AA = 1.8897259886;		# 1Å in Bohrs

(boxW,boxH,boxD,vacuumW,vacuumH,oxideH,electrodeH) = sys.argv;
(boxW,boxH,boxD,vacuumW,vacuumH,oxideH,electrodeH) = (boxW*AA,boxH*AA,boxD*AA,
                                                      vacuumW*AA,vacuumH*AA,
                                                      oxideH*AA,electrodeH*AA);
electrodeW = W-vacuumW/2;
oxideH = H-vacuumH;

S = Space([W,H,D]);

S.addVolume(Volume([0,oxideH,0],[electrodeW,electrodeH,D],"Left electrode"));
S.addVolume(Volume([electrodeW,oxideH,0],[vacuumW,vacuumH,D],"Vacuum"));
S.addVolume(Volume([electrodeW,oxideH,(D-vacuumW)/2],[vacuumW,vacuumW,vacuumW],"Vacuum around molecule"));
S.addVolume(Volume([electrodeW+vacuumW,oxideH,0],[electrodeW,electrodeH,D],"Right electrode"));
S.addVolume(Volume([0,0,0],[W,oxideH,D],"Gate oxide"));

S.buildBoxes();

print """
Include "box.gmsh";

divisions = 1;
"""+S.gmshBoxes()+"""

Physical Volume("Left electrode") = {6, 5, 4, 7, 8, 9};
Physical Volume("Vacuum") = {15, 14, 13, 16, 17, 18};
Physical Volume("Right electrode") = {24, 23, 22, 27, 26, 25};
Physical Volume("Gate oxide") = {3, 2, 1, 12, 11, 10, 21, 20, 19};

Physical Surface("Open boundaries") = {84, 83, 55, 27, 6, 336, 588, 579, 551, 523, 510, 420, 504, 471, 443, 499, 426, 342, 258};
Physical Surface("Left electrode boundary") = {252, 247, 251, 167, 168, 139, 223, 195, 111, 90, 174, 219, 191};
Physical Surface("Right electrode boundary") = {672, 756, 747, 719, 635, 691, 607, 678, 594, 695, 723, 751, 663};
Physical Surface("Gate electrode boundary") = {575, 547, 519, 323, 295, 267, 71, 43, 15};
""";



