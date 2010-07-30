# Dimensions are in Bohr (internal representation)
sub min { return $_[0]<=$_[1]? $_[0]: $_[1]; }
sub max { return $_[0]<=$_[1]? $_[1]: $_[0]; }

($xmax,$xmin) = ($molecule{$moleculename}{xmax}*$AA,$molecule{$moleculename}{xmin}*$AA);
($ymax,$ymin) = ($molecule{$moleculename}{ymax}*$AA,$molecule{$moleculename}{ymin}*$AA);
($zmax,$zmin) = ($molecule{$moleculename}{zmax}*$AA,$molecule{$moleculename}{zmin}*$AA);

%cm = $molecule{$moleculename}{'center of mass'};

($dist_x,$dist_y,$oxideH,$boxW,$boxH,$boxD) = ($dist_x*$AA,$dist_y*$AA,$oxideH*$AA,$boxW*$AA,$boxH*$AA,$boxD*$AA);

$vacuum_width    = $xmax-$xmin+2*$dist_x; # We want $dist_x distance from electrodes to nearest nucleus
$vacuum_height   = $boxH-$oxideH;

$slice_depth     = $boxD;
$electrode_width = ($boxW-$vacuum_width)/2;

$translate_y  = $oxideH+$dist_y-$ymin;# We want $dist_y*Å distance from gate to nearest nucleus

($oxideW,$oxideH,$oxideD) = ($boxW,$oxideH,$boxD);

($translate_x,$translate_y,$translate_z) = ($boxW/2,$translate_y,$boxD/2);

