#!/usr/bin/perl

do 'molecules.pm';

($moleculename) = @ARGV;

do 'config.pm';
do 'kurt-dimensions.pm';

print STDERR "Vacuum width in Bohrs = $xmax-($xmin) + 2*$AA = $vacuum_width\n";

print << "END"

divisions=1;

D  = $slice_depth;  // Depth of space-slice
vacuumheight  = $vacuum_height;
vacuumwidth   = $vacuum_width;
oxideheight   = $Oxide_H;
oxidewidth    = $Oxide_W;
gateheight    = $gate_height;
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
lowerleft[]={0,gateheight,0};
w = electrodewidth;
h = oxideheight;
d = D;
Call BOX3D;

lowerleft[]={electrodewidth,gateheight,0};
w = vacuumwidth;
h = oxideheight;
d = D;
Call BOX3D;

lowerleft[]={electrodewidth+vacuumwidth,gateheight,0};
w = electrodewidth;
h = oxideheight;
d = D;
Call BOX3D;

// Gate electrode
lowerleft[]={0,0,0};
w = electrodewidth;
h = gateheight;
d = D;
Call BOX3D;

lowerleft[]={electrodewidth,0,0};
w = vacuumwidth;
h = gateheight;
d = D;
Call BOX3D;

lowerleft[]={electrodewidth+vacuumwidth,0,0};
w = electrodewidth;
h = gateheight;
d = D;
Call BOX3D;


// Left electrode
lowerleft[]={0,oxideheight+gateheight,0};
w = electrodewidth;
h = electrodeheight;
d = D;
Call BOX3D;

// Right electrode
lowerleft[]={oxidewidth-electrodewidth,oxideheight+gateheight,0};
w = electrodewidth;
h = electrodeheight;
d = D;
Call BOX3D;

// Vacuum
lowerleft[]={electrodewidth,oxideheight+gateheight,0};
w = vacuumwidth;
h = vacuumheight;
d = D;
Call BOX3D;

Physical Volume(1) = {64, 92, 120}; // Gate electrode
Physical Volume(2) = {1, 8, 36};    // Gate oxide
Physical Volume(3) = {204};	    // Vacuum
Physical Volume(4) = {148};	    // Left electrode
Physical Volume(5) = {176};	    // Right electrode

Physical Surface(1) = {28, 6, 27, 56, 34, 62, 84, 75, 252, 230, 247}; // Neumann
Physical Surface(2) = {111, 90, 99, 127, 118, 146, 155, 168, 159, 140, 112}; // Gate electrode
Physical Surface(3) = {196, 195, 174, 191}; // Left electrode
Physical Surface(4) = {202, 219, 215, 224}; // Right electrode

END
