#!/usr/bin/perl

do 'molecules.pm';

($moleculename,$Dx,$Dy,$H) = @ARGV;

do 'config.pm';
do 'dimensions.pm';		# Calculate box{W,H,D}, but in Bohrs 

$oxideH = $H;

system("./SET-mesh-allvars.py $boxW $boxH $boxD $vacuumW $vacuumH $oxideH $electrodeH");

