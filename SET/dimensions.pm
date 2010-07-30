sub min { return $_[0]<=$_[1]? $_[0]: $_[1]; }
sub max { return $_[0]<=$_[1]? $_[1]: $_[0]; }

($xmax,$xmin) = ($molecule{$moleculename}{xmax}*$AA,$molecule{$moleculename}{xmin}*$AA);
($ymax,$ymin) = ($molecule{$moleculename}{ymax}*$AA,$molecule{$moleculename}{ymin}*$AA);
($zmax,$zmin) = ($molecule{$moleculename}{zmax}*$AA,$molecule{$moleculename}{zmin}*$AA);

%cm = $molecule{$moleculename}{'center of mass'};

$vacuumW    = $xmax-$xmin+2*$dist_x; # We want $dist_x distance from electrodes to nearest nucleus
$vacuumH   = 80*$AA;

#&min(50*$AA,$vacuumW*3); # 3 times height of molecule
				       # (including electrons at both
				       # ends -- approximated by 2x6
				       # Bohrs): If vacuum volume is
				       # too thin and tall, we get
				       # thin, tall mesh cells.
$slice_depth = 80*$AA; # &min(50*$AA,$vacuumW*3); # Ditto.
$electrodeW  = 50*$AA;

$translate_y  = $oxide_height+$dist_y-$ymin;# We want 1Å distance from gate to nearest nucleus

# Left and right electrode get respectively half the source-drain voltage Vsd: V_L = -V/2, V_R = V/2
($V_L,$V_R,$V_G) = (-0.5*$Vsd*$eV,0.5*$Vsd*$eV,$Vg*$eV); 

($boxW,$boxH,$boxD) = ($vacuumW+2*$electrodeW,
		       $oxide_height+$vacuumH,$slice_depth);

($oxideW,$oxideH,$oxideD) = ($boxW,$oxide_height,$boxD);

($translate_x,$translate_y,$translate_z) = ($boxW/2,$translate_y,$boxD/2);
