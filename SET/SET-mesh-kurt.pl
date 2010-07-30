#!/usr/bin/perl

do 'molecules.pm';

$moleculename = "benzene-kurt";

do 'config.pm';
do 'kurt-dimensions.pm';

print STDERR "Vacuum width in Bohrs = $xmax-($xmin) + 2*$AA = $vacuum_width\n";

print "./SET-mesh-allvars.py $boxW $boxH $boxD $vacuumW $vacuumH $oxideH $electrodeH\n";
system("./SET-mesh-allvars.py $boxW $boxH $boxD $vacuumW $vacuumH $oxideH $electrodeH");

