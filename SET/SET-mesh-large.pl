#!/usr/bin/perl

do 'molecules.pm';

($moleculename,$H,$W,$D) = @ARGV;

do 'config.pm';
do 'large-dimensions.pm';

($boxH,$boxW,$boxD) = ($H*$AA,$W*$AA,$D*$AA);

($oxideW,$oxideH,$oxideD) = ($boxW,$oxideH,$boxD);
$vacuumH = $boxH-$oxideH;

system("./SET-mesh-allvars.py $boxW $boxH $boxD $vacuumW $vacuumH $oxideH $electrodeH");
