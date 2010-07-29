#!/usr/bin/perl

do 'molecules.pm';

($moleculename, $charge,$Vg,$H,$W,$D) = @ARGV;

$meshsuffix = "${H}-${W}-${D}";
$outputdir  = "SET-${H}-${W}-${D}";

do 'config.pm';
do 'large-dimensions.pm';
do 'fe-config.pm';

($boxH,$boxW,$boxD) = ($H*$AA,$W*$AA,$D*$AA);

($Oxide_W,$Oxide_H,$Oxide_D) = ($boxW,$oxide_height,$boxD);
$vacuum_height = $boxH-$Oxide_H;


system("./SET-input-allvars.pl $moleculename, $charge $Vg $Vsd"
       ." $dist_x $dist_y $oxideH"
       ." $boxW $boxH $boxD"
       ." $dielectric_constant"
       ." $meshsuffix $outputdir $feconfig");
