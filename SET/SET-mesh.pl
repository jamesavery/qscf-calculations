#!/usr/bin/perl

do 'molecules.pm';

($moleculename) = @ARGV;

do 'config.pm';
do 'dimensions.pm';

system("./SET-mesh-allvars.pl $moleculename $dist_x $dist_y $oxideH $boxW $boxH $boxD");
