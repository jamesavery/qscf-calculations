#!/usr/bin/perl

do 'molecules.pm';

($moleculename, $charge,$Vg,$Dx,$Dy,$H) = @ARGV;
$Vsd = 0;			# Perhaps add to parameters as well.

do 'config.pm';
do 'dimensions.pm';		# Calculate box{W,H,D}, but in Bohrs 
do 'fe-config.pm';

# Input to x-allvars.sh must be in Aangstrom, not in Bohrs.
($boxW,$boxH,$boxD) = ($boxW/$AA,$boxH/$AA,$boxD/$AA);


system("./SET-input-allvars.pl $moleculename, $charge $Vsd $Vg"
       ." $Dx $Dy $H"
       ." $boxW $boxH $boxD"
       ." $dielectric_constant"
       ." $feconfig");
