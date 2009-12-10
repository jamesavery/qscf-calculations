sub min { return $_[0]<=$_[1]? $_[0]: $_[1]; }
sub max { return $_[0]<=$_[1]? $_[1]: $_[0]; }

($xmax,$xmin) = ($molecule{$moleculename}{xmax}*$AA,$molecule{$moleculename}{xmin}*$AA);
($ymax,$ymin) = ($molecule{$moleculename}{ymax}*$AA,$molecule{$moleculename}{ymin}*$AA);
($zmax,$zmin) = ($molecule{$moleculename}{zmax}*$AA,$molecule{$moleculename}{zmin}*$AA);

%cm = $molecule{$moleculename}{'center of mass'};

$vacuum_width    = $xmax-$xmin+2*$dist_x; # We want $dist_x distance from electrodes to nearest nucleus
$vacuum_height   = &min(50*$AA,$vacuum_width*3); # 3 times height of molecule
				       # (including electrons at both
				       # ends -- approximated by 2x6
				       # Bohrs): If vacuum volume is
				       # too thin and tall, we get
				       # thin, tall mesh cells.
$slice_depth     = &min(50*$AA,$vacuum_width*3); # Ditto.
$electrode_width = 50*$AA;

$translate_y  = $oxide_height+$dist_y-$ymin;		# We want 1Å distance from gate to nearest nucleus

# Left and right electrode get respectively half the source-drain voltage Vsd: V_L = -V/2, V_R = V/2
($V_L,$V_R,$V_G) = (-0.5*$Vsd*$eV,0.5*$Vsd*$eV,$Vg*$eV); 

($boxW,$boxH,$boxD) = ($vacuum_width+2*$electrode_width,$oxide_height+$vacuum_height,$slice_depth);
($boxw,$boxh,$boxd) = ($boxW/2,$boxH/2,$boxD/2);

($Oxide_w,$Oxide_h,$Oxide_d) = ($boxw,$Oxide_H/2,$boxd);
($Oxide_W,$Oxide_H,$Oxide_D) = ($boxW,$oxide_height,$boxD);
($Oxide_x,$Oxide_y,$Oxide_z) = ($Oxide_w,$Oxide_h,$Oxide_d);

($Hx,$Hy,$Hz) = ($boxw,$translate_y,$boxd);
