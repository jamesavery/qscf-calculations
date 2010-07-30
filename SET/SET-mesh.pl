#!/usr/bin/perl

do 'molecules.pm';

($moleculename) = @ARGV;

do 'config.pm';
do 'dimensions.pm';

system("./SET-mesh-allvars.py $boxW $boxH $boxD $vacuumW $vacuumH $oxideH $electrodeH");
