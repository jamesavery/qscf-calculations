$eV = 0.0367493254;		# 1 eV in Hartrees
$nm = 18.897259886;		# 1 nm in Bohrs
$AA = 1.8897259886;		# 1Å in Bohrs

%molecule = (		# Dimensions are in Ångström
    "H"   => {		# H-atom for testing
    	hosts => "all",
	basis => "OPV5basis.in",
	xmin => 0, xmax=>0,
	ymin => 0, zmax=>0,
	zmin => 0, ymax=>0,
	'center of mass' => {'x'=>0,'y'=>0,'z'=>0}
     }, 
    "C60" => {
    	hosts => "lxir024",
	basis => "C60basis.in",
	xmin =>-3.34959, xmax => 3.34529,
	ymin =>-3.48836, ymax => 3.49999,
	zmin =>-3.55242, zmax => 3.53589,
	'center of mass' => {'x'=>-0.00220283,'y'=>0.00574317,'z'=>-0.0084725}
    },
    "OPV5-tertbutyl-vnl" => {	# Unoptimized OPV5 with tertbutyl termination
    	hosts => "lxir020",
	basis => "OPV5basis.in",
	xmin =>-19.2608, xmax => 19.2539,
	ymin =>-2.68873, ymax => 2.69061,
	zmin =>-2.16172, zmax => 2.16361,
	'center of mass' => {'x'=>0.0000816435,'y'=>0.0000118029, 'z'=>0.000025241}
    },
    "OPV5-TB-PW91" => { # Firefly/PW91/cc-pVDZ-optimized OPV5-tertbutyl molecule
    	hosts => "lxir020",
       basis => "OPV5basis.in",
       xmin =>-19.8337, xmax => 19.8371,
       ymin =>-2.48477, ymax => 2.49103,
       zmin =>-2.21392, zmax => 2.21432,
       'center of mass' => {'x'=>0.000616014,'y'=>0.0000948292, 'z'=>0.000318515}
    },
    "OPV5-vnl" => {		# Unoptimized OPV5
    	hosts => "lxir024",
	basis => "OPV5basis.in",
	xmin => -16.9533,  xmax => 16.9665,
	ymin => -0.0010447,ymax => 0.00131549,
	zmin => -2.45939,  zmax => 2.45729,
	'center of mass' => {'x'=>-0.000142393,'y'=>1.33e-6, 'z'=>0.0000229411}
    },
    "OPV5.18" => {		# OPV5 geometry optimization step 18 using GAMESS/B3LYP
    	hosts => "all",
	basis => "OPV5basis.in",
	xmin =>-16.809, xmax => 16.8062,
	ymin =>-0.00112449, ymax => 0.00131399,
	zmin =>-2.41489, zmax => 2.41143,
	'center of mass' => {'x'=>-0.00161484,'y'=>2.27424e-6, 'z'=>0.000248661}
    },
    "OPV5-B3LYP" => {		# Converged OPV5 geometry optimization using Firefly/cc-pVDZ/B3LYP
    	hosts => "lxir026",
	basis => "OPV5basis.in",
	xmin =>-16.984, xmax => 16.9813,
	ymin =>-0.00112056, ymax => 0.0013249,
	zmin =>-2.39927, zmax => 2.39939,
	'center of mass' => {'x'=>-0.00140013,'y'=>-2.73793e-6, 'z'=>0.000163514}
    },
    "OPV5-GAMESS-B3LYP" => {	# Converged OPV5 geometry optimization using GAMESS/cc-pVDZ/B3LYP
    	hosts => "lxir022",
	basis => "OPV5basis.in",
	xmin =>-16.9962, xmax => 16.9934,
	ymin =>-0.0010763, ymax => 0.00128219,
	zmin =>-2.40537, zmax => 2.40579,
	'center of mass' => {'x'=>-0.00139303,'y'=>-6.02668e-6, 'z'=>0.00017679}
    },
    "OPV5-PW91" => {		# Converged OPV5 geometry optimization using Firefly/cc-pVDZ/PW91
    	hosts => "lxir022",
	basis => "OPV5basis.in",
	xmin =>-16.9938, xmax => 16.9912,
	ymin =>-0.00108166, ymax => 0.00133163,
	zmin =>-2.41203, zmax => 2.41204,
	'center of mass' => {'x'=>-0.00142308,'y'=>-5.71626e-6, 'z'=>0.000158929}
    },

   # "OPV5-tertbutyl" => {	# B3LYP/ccVDZ optimized OPV5 with tertbutyl termination
   # 	hosts => "lxir024",
#	basis => "OPV5basis.in",
#    },
    "benzene" => { 
    	hosts => "all",
	basis => "benzenebasis.in",
	xmin =>-2.50069, xmax => 2.50069,
	ymin =>0, ymax => 0,
	zmin =>-2.16569, zmax => 2.16568,
	'center of mass' => {'x'=>0.,'y'=>0, 'z'=>0.}
    },
    "benzene-kurt" => {
    	hosts => "lxir020",
	basis => "benzenebasis.in",
	xmin =>-2.50069, xmax => 2.50069,
	ymin =>0, ymax => 0,
	zmin =>-2.16569, zmax => 2.16568,
	'center of mass' => {'x'=>0.,'y'=>0, 'z'=>0.}
    },
    'OPV5-tBu-BP86-Lein' => {
	hosts => 'lxir020',
	basis => 'OPV5basis.in',
	xmin =>-19.1712, xmax => 19.1715,
	ymin =>-2.7228, ymax => 2.72516,
	zmin =>-2.96158, zmax => 0.708976,
	'center of mass' => {'x'=>-0.0000718192,'y'=>0.000573339, 'z'=>0.225061}
    },
   'OPV5-tBu-PW91-Lein' => {
	hosts => 'all',
	basis => 'OPV5basis',
	xmin =>-19.1182, xmax => 19.1179,
	ymin =>-0.712431, ymax => 2.9347,
	zmin =>-2.72696, zmax => 2.72378,
	'center of mass' => {'x'=>0.0000837006,'y'=>-0.224554, 'z'=>-0.00073013}
    }

    );

