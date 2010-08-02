#!/usr/bin/perl

do 'molecules.pm';

($moleculename,$Dx,$Dy,$H) = @ARGV;

do 'config.pm';
$oxideH = $H;
$dist_x = $Dx;
$dist_y = $Dy;
do 'dimensions.pm';		# Calculate box{W,H,D}, but in Bohrs 

system("./SET-mesh-allvars.py $boxW $boxH $boxD $vacuumW $vacuumH $oxideH $electrodeH");

