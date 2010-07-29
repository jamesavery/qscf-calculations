#!/usr/bin/perl

do 'molecules.pm';

$moleculename="benzene-kurt";
($charge,$Vsd,$Vg) = @ARGV;

do 'config.pm';
do 'kurt-dimensions.pm';
do 'fe-config.pm';

system("./SET-input-allvars.pl $moleculename, $charge $Vsd $Vg"
       ." $dist_x $dist_y $oxideH"
       ." $boxW $boxH $boxD"
       ." $dielectric_constant"
       ." $feconfig");
