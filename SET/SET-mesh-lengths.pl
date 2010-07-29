#!/usr/bin/perl

do 'molecules.pm';

($moleculename,$Dx,$Dy,$H) = @ARGV;

do 'config.pm';
do 'dimensions.pm';		# Calculate box{W,H,D}, but in Bohrs 

($boxW,$boxH,$boxD) = ($boxW/$AA,$boxH/$AA,$boxD/$AA);

system("./SET-mesh-allvars.pl $moleculename $Dx $Dy $H $boxW $boxH $boxD");

