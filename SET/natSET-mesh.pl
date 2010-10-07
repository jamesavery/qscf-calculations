#!/usr/bin/perl

do 'molecules.pm';

($moleculename) = @ARGV;

do 'config.pm';
do 'natdimensions.pm';

print STDERR "./natSET-mesh-allvars.py $boxW $boxH $boxD $vacuumW $vacuumH $oxideH $electrodeH\n";
system("./natSET-mesh-allvars.py $boxW $boxH $boxD $vacuumW $vacuumH $oxideH $electrodeH");
