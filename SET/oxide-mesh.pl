#!/usr/bin/perl

# This file generates the mesh to go with oxide-input.pl

do 'molecules.pm';

($moleculename,$Dy,$H) = @ARGV;

do 'config.pm';
do 'dimensions.pm';

$Oxide_H      = $H*$AA;
$dist_y       = $Dy*$AA;
$translate_y  = $Oxide_H+$dist_y-$ymin;
$Hy           = $translate_y;

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

// Gate oxide
lowerleft[]={0,0,0};
w = oxidewidth;
h = oxideheight;
d = oxidewidth;
Call BOX3D;

// Vacuum
lowerleft[]={0,oxideheight,0};
w = oxidewidth;
h = vacuumheight;
d = oxidewidth;
Call BOX3D;


Physical Volume(1) = {8};	// Vacuum
Physical Volume(2) = {1};	// Gate oxide

Physical Surface(1) = {55, 56, 47, 34}; // Vacuum boundaries
Physical Surface(2) = {51};             // Vacuum top
Physical Surface(3) = {27, 6, 28, 19};  // Oxide boundaries
Physical Surface(4) = {15};	        // Grounding 

END
