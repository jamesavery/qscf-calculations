#!/usr/bin/perl

# This file produces a set-up consisting of three volumes representing
# respectively left electrode, vacuum, and right electrode. The
# electrodes are represented by fixed regions. Molecule is in the
# middle of the vacuum volume.
#
# This should give the same result as running
# electrodes-input.simple.pl, which simulates the
# left/right-electrodes using boundary value conditions.

do 'molecules.pm';

($moleculename, $charge,$Vsd,$Dx,$H) = @ARGV;

do 'config.pm';
do 'dimensions.pm';
do 'fe-config.pm';

$dist_x = $Dx*$AA;
$vacuum_width=$xmax-$xmin+2*$dist_x;
$vacuum_height   = $H*$AA;
$slice_depth     = $H*$AA;

# Left and right electrode get respectively half the source-drain voltage Vsd: V_L = -V/2, V_R = V/2
($V_L,$V_R) = (-0.5*$Vsd*$eV,0.5*$Vsd*$eV); 

($Hx, $Hy, $Hz) = ($boxW/2,$vacuum_height/2,$slice_depth/2);

print << "END"

include:0 = "opv5parameters.in" 
include:1 = "bases/$molecule{$moleculename}{basis}"


molecule<Molecule>: ( 
  symmetry = auto
  unit = angstrom
  origin = [0 0 0]
  symmetry_frame = [[1 0 0] [0 0 1] [0 1 0]]
END
; 
  print `cat geometries/${moleculename}.in`;
print <<"END"
)


lattice<Lattice>:(
	basis=\$:molecule
        translate_basis = [$Hx $Hy $Hz]
	unitcell = [ [ $boxW 0 0 ] [ 0 $vacuum_height 0 ] [ 0 0 $boxD ] ]	
	unitcell:unit=bohr
)

volumes<PhysicalVolumesParam>:(
	{id description volume_type value} = {
	   1 "Left electrode"  fixed $V_L
	   2 "Right electrode" fixed $V_R
	   3 "Vacuum"          dielectric 1
	}
)


surfaces<PhysicalSurfacesParam>:(
	{id description boundary_type boundary_value} = {
	    1 "Left electrode"      dirichlet $V_L
	    2 "Right electrode"     dirichlet $V_R
	    3 "Vacuum boundaries"   neumann 0
	}
)


calculator<LatticeFEMCalculator>: (
    lattice= \$:lattice
    basisset=\$:basissetDZP
    boundaryconditions = [ neumann neumann neumann ]
    meshcutoff:unit=hartree
    kpoints:monkhorstpack = [1 1 1]
    surfaces = \$:surfaces
    volumes  = \$:volumes
    electrontemperature = $convergenceparams{'electrontemperature'}
    electrontemperature:unit = ev
    mesh_file = ${moleculename}-electrodes-${Dx}-${H}.msh
    charge = $charge

    fe_order = $feparams{'fe_order'}
    refinement_strategy   = $feparams{'refinement_strategy'}
    centers_max_diameter  = $feparams{'centers_max_diameter'}
    centers_near_diameter = $feparams{'centers_near_diameter'}
    end_refine = $feparams{'end_refine'}

    initial_refinement=$feparams{'initial_refinement'}
    final_dE=$feparams{'final_dE'}

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

