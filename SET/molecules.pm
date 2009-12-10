$eV = 0.0367493254;		# 1 eV in Hartrees
$nm = 18.897259886;		# 1 nm in Bohrs
$AA = 1.8897259886;		# 1Å in Bohrs

%molecule = (		# Dimensions are in Ångström
    "C60" => {
	basis => "C60basis.in",
	xmin =>-3.34959, xmax => 3.34529,
	ymin =>-3.48836, ymax => 3.49999,
	zmin =>-3.55242, zmax => 3.53589,
	'center of mass' => {'x'=>-0.00220283,'y'=>0.00574317,'z'=>-0.0084725}
    },
    "OPV5-tertbutyl-vnl" => {	# Unoptimized OPV5 with tertbutyl termination
	basis => "OPV5basis.in",
	xmin =>-19.2608, xmax => 19.2539,
	ymin =>-2.68873, ymax => 2.69061,
	zmin =>-2.16172, zmax => 2.16361,
	'center of mass' => {'x'=>0.0000816435,'y'=>0.0000118029, 'z'=>0.000025241}
    },
    "OPV5-vnl" => {		# Unoptimized OPV5
	basis => "OPV5basis.in",
	xmin => -16.9533,  xmax => 16.9665,
	ymin => -0.0010447,ymax => 0.00131549,
	zmin => -2.45939,  zmax => 2.45729,
	'center of mass' => {'x'=>-0.000142393,'y'=>1.33e-6, 'z'=>0.0000229411}
    },
    "OPV5-tertbutyl" => {	# B3LYP/ccVDZ optimized OPV5 with tertbutyl termination
	basis => "OPV5basis.in",
    },
    "OPV5" => {			# B3LYP/ccVDZ optimized OPV5
	basis => "OPV5basis.in",
    }
    
    );

