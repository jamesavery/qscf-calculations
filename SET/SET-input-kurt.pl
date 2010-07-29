#!/usr/bin/perl

do 'molecules.pm';


$meshsuffix = "set";
$outputdir  = "SET-${charge}-${Vg}-${Vsd}";

$moleculename="benzene-kurt";
($charge,$Vsd,$Vg) = @ARGV;

do 'config.pm';
do 'kurt-dimensions.pm';
do 'fe-config.pm';

system("./SET-input-allvars.pl $moleculename, $charge $Vg $Vsd"
       ." $dist_x $dist_y $oxideH"
       ." $boxW $boxH $boxD"
       ." $dielectric_constant"
       ." $meshsuffix $outputdir $feconfig");
