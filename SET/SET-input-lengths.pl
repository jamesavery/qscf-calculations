#!/usr/bin/perl

do 'molecules.pm';

($moleculename, $charge,$Vg,$Vsd,$Dx,$Dy,$H) = @ARGV;

$meshsuffix = "set-${Dx}-${Dy}-${H}";
$outputdir  = "set-${Dx}-${Dy}-${H}"; # I'm mostly interested in the different meshes.
                                      # If I need solutions as well, charge and V{sd,g} 
                                      # need to be added to the path.

do 'config.pm';
do 'dimensions.pm';		# Calculate box{W,H,D}, but in Bohrs 
do 'fe-config.pm';

# Input to x-allvars.sh must be in Aangstrom, not in Bohrs.
($boxW,$boxH,$boxD) = ($boxW,$boxH,$boxD);


system("./SET-input-allvars.pl $moleculename $charge $Vg $Vsd"
       ." $Dx $Dy $H"
       ." $boxW $boxH $boxD"
       ." $dielectric_constant"
       ." $meshsuffix $outputdir $feconfig");
