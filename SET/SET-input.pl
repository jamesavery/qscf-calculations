#!/usr/bin/perl

do 'molecules.pm';

($moleculename, $charge,$Vg,$Vsd,$feconfig) = @ARGV;

$meshsuffix = "set";
$outputdir  = "SET-${charge}-${Vg}-${Vsd}";

if(!defined($feconfig)){ $feconfig = "fe-config"; }
do 'config.pm';
do 'dimensions.pm';
do "${feconfig}.pm";


system("./SET-input-allvars.pl $moleculename, $charge $Vg $Vsd"
       ." $dist_x $dist_y $oxideH"
       ." $boxW $boxH $boxD"
       ." $dielectric_constant"
       ." $meshsuffix $outputdir  $feconfig");
