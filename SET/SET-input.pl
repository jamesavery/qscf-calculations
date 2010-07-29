#!/usr/bin/perl

do 'molecules.pm';

($moleculename, $charge,$Vsd,$Vg,$feconfig) = @ARGV;

if(!defined($feconfig)){ $feconfig = "fe-config"; }
do 'config.pm';
do 'dimensions.pm';
do "${feconfig}.pm";

system("./SET-input-allvars.pl $moleculename, $charge $Vsd $Vg"
       ." $dist_x $dist_y $oxideH"
       ." $boxW $boxH $boxD"
       ." $dielectric_constant"
       ." $feconfig");
