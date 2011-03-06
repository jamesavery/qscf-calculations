sub min { return $_[0]<=$_[1]? $_[0]: $_[1]; }
sub max { return $_[0]<=$_[1]? $_[1]: $_[0]; }

($xmax,$xmin) = ($molecule{$moleculename}{xmax}*$AA,$molecule{$moleculename}{xmin}*$AA);
($ymax,$ymin) = ($molecule{$moleculename}{ymax}*$AA,$molecule{$moleculename}{ymin}*$AA);
($zmax,$zmin) = ($molecule{$moleculename}{zmax}*$AA,$molecule{$moleculename}{zmin}*$AA);

%cm = $molecule{$moleculename}{'center of mass'};

$vacuumW  	 = 10.63;
$vacuumH    	 = 7.23;
$slice_depth     = 12;
$electrodeW 	 = 4;
$oxideH    	 = 3.77;
$gateH     	 = 1.0;
$dist_y          = 1.23;
$translate_y     = 6;

# Left and right electrode get respectively half the source-drain voltage Vsd: V_L = -V/2, V_R = V/2
($V_L,$V_R,$V_G) = (-0.5*$Vsd*$eV,0.5*$Vsd*$eV,$Vg*$eV); 

($boxW,$boxH,$boxD) = ($vacuumW+2*$electrodeW,
		       $oxideH+$vacuumH,$slice_depth);
($bW,$bH,$bD) = (18.63,11,12);

print STDERR "(boxW,boxH,boxD) = ($boxW,$boxH,$boxD) - should be ($bW,$bH,$bD)\n";

($oxideW,$oxideH,$oxideD) = ($boxW,$oxideH,$boxD);
$electrodeH = $boxH-$oxideH;

($Hx,$Hy,$Hz) = ($boxW/2,$translate_y,$boxD/2);

($tx,$ty,$tz) = (9.315,6,6);
print STDERR "translate ($Hx,$Hy,$Hz) - should be ($tx,$ty,$tz)\n";
