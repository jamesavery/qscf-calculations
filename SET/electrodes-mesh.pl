#!/usr/bin/perl

# This file generates the mesh to go with electrodes-input.pl

do 'molecules.pm';

($moleculename) = @ARGV;

do 'config.pm';
do 'dimensions.pm';

print STDERR "Vacuum width in Bohrs = $xmax-($xmin) + 2*$AA = $vacuum_width\n";

print << "END"

divisions=1;

D  = $slice_depth;  // Depth of space-slice
vacuumheight  = $vacuum_height;
vacuumwidth   = $vacuum_width;
oxideheight   = $Oxide_H;
oxidewidth    = $Oxide_W;
electrodewidth  = (oxidewidth-vacuumwidth)/2.0;
electrodeheight = vacuumheight;

Function BOX3D

    p1 = newp; Point(p1) = {lowerleft[0] + 0,lowerleft[1] + 0,lowerleft[2]};
    p2 = newp; Point(p2) = {lowerleft[0] + w,lowerleft[1] + 0,lowerleft[2]};
    p3 = newp; Point(p3) = {lowerleft[0] + w,lowerleft[1] + h,lowerleft[2]};
    p4 = newp; Point(p4) = {lowerleft[0] + 0,lowerleft[1] + h,lowerleft[2]};

    l1 = newl; Line(l1) = {p1,p2};
    l2 = newl; Line(l2) = {p2,p3};
    l3 = newl; Line(l3) = {p3,p4};
    l4 = newl; Line(l4) = {p4,p1};

    c1 = newc; Line Loop(c1) = {l1,l2,l3,l4};
    
    s1 = news; Plane Surface(s1) = {c1};
    
    Transfinite Line{l1:l4}=divisions;
    Transfinite Surface{s1};
    Recombine Surface{s1};

    resultV = newv;
    Volume(resultV) = Extrude {0,0,d}{
	Surface{s1}; Layers{divisions}; Recombine;
    };

    Return


// Left electrode
lowerleft[]={0,0,0};
w = electrodewidth;
h = electrodeheight;
d = D;
Call BOX3D;

// Right electrode
lowerleft[]={oxidewidth-electrodewidth,0,0};
w = electrodewidth;
h = electrodeheight;
d = D;
Call BOX3D;

// Vacuum
lowerleft[]={electrodewidth,0,0};
w = vacuumwidth;
h = vacuumheight;
d = D;
Call BOX3D;


Physical Surface(0) = {19, 6, 23, 27, 15, 28};   // Left electrode
Physical Surface(1) = {51, 34, 43, 56, 47, 55};  // Right electrode
Physical Surface(87) = {71, 84, 79, 62};         // Vacuum 

Physical Volume(0) = {1};	   // Left electrode
Physical Volume(1) = {8};          // Right electrode
Physical Volume(2) = {36};         // Vacuum 



END
