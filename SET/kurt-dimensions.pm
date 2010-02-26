sub min { return $_[0]<=$_[1]? $_[0]: $_[1]; }
sub max { return $_[0]<=$_[1]? $_[1]: $_[0]; }

($xmax,$xmin) = ($molecule{$moleculename}{xmax}*$AA,$molecule{$moleculename}{xmin}*$AA);
($ymax,$ymin) = ($molecule{$moleculename}{ymax}*$AA,$molecule{$moleculename}{ymin}*$AA);
($zmax,$zmin) = ($molecule{$moleculename}{zmax}*$AA,$molecule{$moleculename}{zmin}*$AA);

%cm = $molecule{$moleculename}{'center of mass'};

$vacuum_width    = 10.63*$AA;
$vacuum_height   = 7.23*$AA;
$slice_depth     = 120*$AA;
$electrode_width = 4*$AA;
$oxide_height    = 3.77*$AA;
$gate_height     = 1.0*$AA;
$dist_y          = 1.23*$AA;
$translate_y     = 6*$AA;

# Left and right electrode get respectively half the source-drain voltage Vsd: V_L = -V/2, V_R = V/2
($V_L,$V_R,$V_G) = (-0.5*$Vsd*$eV,0.5*$Vsd*$eV,$Vg*$eV); 

($boxW,$boxH,$boxD) = ($vacuum_width+2*$electrode_width,
		       $oxide_height+$vacuum_height,$slice_depth);
($bW,$bH,$bD) = (18.63*$AA,11*$AA,12*$AA);

print STDERR "(boxW,boxH,boxD) = ($boxW,$boxH,$boxD) - should be ($bW,$bH,$bD)\n";

($Oxide_W,$Oxide_H,$Oxide_D) = ($boxW,$oxide_height,$boxD);

($Hx,$Hy,$Hz) = ($boxW/2,$translate_y,$boxD/2);

($tx,$ty,$tz) = (9.315*$AA,6*$AA,6*$AA);
print STDERR "translate ($Hx,$Hy,$Hz) - should be ($tx,$ty,$tz)\n";
