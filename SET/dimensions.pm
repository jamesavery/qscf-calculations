# Dimensions are in Aangstrom (input representation)
sub min { return $_[0]<=$_[1]? $_[0]: $_[1]; }
sub max { return $_[0]<=$_[1]? $_[1]: $_[0]; }

($xmax,$xmin) = ($molecule{$moleculename}{xmax},$molecule{$moleculename}{xmin});
($ymax,$ymin) = ($molecule{$moleculename}{ymax},$molecule{$moleculename}{ymin});
($zmax,$zmin) = ($molecule{$moleculename}{zmax},$molecule{$moleculename}{zmin});

%cm = $molecule{$moleculename}{'center of mass'};

$vacuumW    = $xmax-$xmin+2*$dist_x; # We want $dist_x distance from electrodes to nearest nucleus
$vacuumH   = 80;

$slice_depth = 80; 
$electrodeW  = 50;
$electrodeH = $vacuumH; 	# Change afterwards to get thinner electrodes.

$translate_y  = $oxide_height+$dist_y-$ymin;# We want 1Å distance from gate to nearest nucleus

($boxW,$boxH,$boxD) = ($vacuumW+2*$electrodeW,
		       $oxide_height+$vacuumH,$slice_depth);

($oxideW,$oxideH,$oxideD) = ($boxW,$oxide_height,$boxD);

($translate_x,$translate_y,$translate_z) = ($boxW/2,$translate_y,$boxD/2);
