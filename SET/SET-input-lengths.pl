#!/usr/bin/perl

do 'molecules.pm';

($moleculename, $charge,$Vg,$Vsd,$Dx,$Dy,$H) = @ARGV;

$meshsuffix = "set-${Dx}-${Dy}-${H}";
$outputdir  = "set-${Dx}-${Dy}-${H}"; # I'm mostly interested in the different meshes.
                                      # If I need solutions as well, charge and V{sd,g} 
                                      # need to be added to the path.

do 'config.pm';
$oxideH = $H;
do 'dimensions.pm';
do 'fe-config.pm';


system("./SET-input-allvars.pl $moleculename $charge $Vg $Vsd"
       ." $Dx $Dy $H"
       ." $boxW $boxH $boxD"
       ." $dielectric_constant"
       ." $meshsuffix $outputdir $feconfig");
