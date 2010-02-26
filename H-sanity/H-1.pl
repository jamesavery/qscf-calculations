#!/usr/bin/perl

# H + charge in a vacuum.

$eV = 0.0367493254;		# 1 eV in Hartrees
$nm = 18.897259886;		# 1 nm in Bohrs

($charge) = @ARGV;

do 'fe-config.pm';

my ($charge) = @ARGV;

($boxW,$boxH,$boxD) = (10000,10000,10000);
($boxw,$boxh,$boxd) = ($boxW/2,$boxH/2,$boxD/2);

($Hx,$Hy,$Hz) = ($boxw,$boxh,$boxd);

print << "END"

Hdzp<PaoParam>: (
        label=H
        setupfile="H_pz.UPF"
        {n   l   energyshift   deltarinner  v0  charge splitnorm  polarized} = {
        1   0      0.005         0.8    20.  0.0     0.0       0
        1   0      0.005         0.8    20.  0.0     0.4       0
        2   1      0.005         0.8    20.  0.0     0.0       1
 }
)

basissetDZP<BasisSetParam>: (
        paoparam = [ \$:Hdzp ]
        energycutoff=2500
        numberofreciprocalpoints=1024
        dr=0.01
)

H<Molecule>: ( 
  symmetry = auto
  unit = angstrom
  origin = [0 0 0]
  symmetry_frame = [[1 0 0] [0 0 1] [0 1 0]]
  { atom_labels atoms geometry } = {
      H H [ 0 0 0 ]
  }
)


lattice<Lattice>:(
	basis=\$:H
        translate_basis = [$Hx $Hy $Hz]
	unitcell = [ [ $boxW 0 0 ] [ 0 $boxH 0 ] [ 0 0 $boxD ] ]	
	unitcell:unit=bohr
)


surfaces<PhysicalSurfacesParam>:(
	{id description boundary_type boundary_value} = {
	    0 "-x" dirichlet 0
	    1 "+x" neumann 0
	    2 "-y" neumann 0
	    3 "+y" neumann 0
	    4 "-z" neumann 0
	    5 "+z" neumann 0
	}
)


calculator<LatticeFEMCalculator>: (	
    lattice= \$:lattice
    basisset=\$:basissetDZP
    boundaryconditions = [ neumann neumann neumann ]
    surfaces=\$:surfaces
    meshcutoff:unit=hartree
    kpoints:monkhorstpack = [1 1 1]
    electrontemperature = $convergenceparams{electrontemperature}
    electrontemperature:unit = ev
    charge = $charge
    initial_refinement=$feparams{'initial_refinement'}
    final_dE=$feparams{'final_dE'}
    fe_order = $feparams{'fe_order'}
    refinement_strategy   = $feparams{'refinement_strategy'}
    centers_max_diameter  = $feparams{'centers_max_diameter'}
    centers_near_diameter = $feparams{'centers_near_diameter'}
    end_refine = $feparams{'end_refine'}

    write_mesh = $feparams{'write_mesh'}
    write_solution = $feparams{'write_solution'}
)

qscf<ScfParam>: (
	calculator=\$:calculator
	diis:n = 8
	diis:start = 1
	diis:dampingfactor = 0.8
	precondition= false
        tolerance=$convergenceparams{tolerance}
	variable=hamiltonian
        maxiterations=$convergenceparams{maxiterations}
	verbose=10
)

END


