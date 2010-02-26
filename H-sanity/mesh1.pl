#!/usr/bin/perl

do 'molecules.pm';

do 'config.pm';

sub min { return $_[0]<=$_[1]? $_[0]: $_[1]; }
sub max { return $_[0]<=$_[1]? $_[1]: $_[0]; }


($boxW,$boxH,$boxD) = (800,400,400);
$diW     = 400;
$vacuumW = $boxW-$diW;

print << "END"

divisions=1;

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

// Left electrode/dielectric
lowerleft[]={0,0,0};
w = $diW;
h = $boxH;
d = $boxD;
Call BOX3D;

// Vacuum
lowerleft[]={$diW,0,0};
w = $vacuumW;
h = $boxH;
d = $boxD;
Call BOX3D;


Physical Volume(1) = {8};	// Vacuum
Physical Volume(2) = {1};	// Left electrode/dielectric
Physical Surface(1) = {56, 51, 34, 47, 43};// Vacuum boundaries
Physical Surface(2) = {15, 28, 6, 27, 23}; // Electrode/dielectric boundaries




END
