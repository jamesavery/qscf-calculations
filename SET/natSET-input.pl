#!/usr/bin/perl

do 'molecules.pm';

($moleculename, $charge,$Vg,$Vsd,$feconfig) = @ARGV;

$meshsuffix = "natSET";
$outputdir  = "natSET-${charge}-${Vg}-${Vsd}";

if(!defined($feconfig)){ $feconfig = "fe-config"; }
do 'config.pm';
do 'natdimensions.pm';
do "${feconfig}.pm";

$dist_y = $dist_y + $electrodeH;

system("./SET-input-allvars.pl $moleculename $charge $Vg $Vsd"
       ." $dist_x $dist_y $oxideH"
       ." $boxW $boxH $boxD"
       ." $dielectric_constant"
       ." $meshsuffix $outputdir  $feconfig");
