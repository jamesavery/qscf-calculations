# Dimensions are in Aangstrom (input representation)
sub min { return $_[0]<=$_[1]? $_[0]: $_[1]; }
sub max { return $_[0]<=$_[1]? $_[1]: $_[0]; }

($xmax,$xmin) = ($molecule{$moleculename}{xmax},$molecule{$moleculename}{xmin});
($ymax,$ymin) = ($molecule{$moleculename}{ymax},$molecule{$moleculename}{ymin});
($zmax,$zmin) = ($molecule{$moleculename}{zmax},$molecule{$moleculename}{zmin});

%cm = $molecule{$moleculename}{'center of mass'};

$vacuumW    = 20; # We want $dist_x distance from electrodes to nearest nucleus
$vacuumH   = 150;

$slice_depth = 200; 
$electrodeW  = ($slice_depth-$vacuumW)/2.;
$electrodeH = 25; 	

$translate_y  = $oxideH+$electrodeH+$dist_y-$ymin;# We want dist_y distance from electrodes to nearest nucleus

($boxW,$boxH,$boxD) = ($vacuumW+2*$electrodeW,
		       $oxideH+$vacuumH,$slice_depth);

($oxideW,$oxideH,$oxideD) = ($boxW,$oxideH,$boxD);

($translate_x,$translate_y,$translate_z) = ($boxW/2,$translate_y,$boxD/2);
