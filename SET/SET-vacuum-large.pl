#!/usr/bin/perl

do 'molecules.pm';

($moleculename, $charge,$H,$W,$D) = @ARGV;

do 'config.pm';
do 'large-dimensions.pm';
do 'fe-config.pm';

($boxH,$boxW,$boxD) = ($H*$AA,$W*$AA,$D*$AA);

# Left and right electrode get respectively half the source-drain voltage Vsd: V_L = -V/2, V_R = V/2

($oxideW,$oxideH,$oxideD) = ($boxW,$oxideH,$boxD);
$vacuumH = $boxH-$oxideH;

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
	unitcell = [ [ $boxW 0 0 ] [ 0 $boxH 0 ] [ 0 0 $boxD ] ]	
	unitcell:unit=bohr
)

volumes<PhysicalVolumesParam>:(
	{id description volume_type value} = {
	   1 "Vacuum"      dielectric 1
	   2 "Vacuum"      dielectric 1
	   3 "Vacuum" dielectric 1 
	   4 "Vacuum" dielectric 1
	}
)


surfaces<PhysicalSurfacesParam>:(
	{id description boundary_type boundary_value} = {
	    1 "Vacuum boundaries"   dirichlet 0
	    2 "Ground voltage"      dirichlet 0
	    3 "Left electrode"      dirichlet 0
	    4 "Right electrode"     dirichlet 0
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
    electrontemperature = $convergenceparams{electrontemperature}
    electrontemperature:unit = ev
    mesh_file = ${moleculename}-${H}-${W}-${D}.msh
    gate=\$:gate
    charge = $charge

    final_dE=$feparams{'final_dE'}
    final_dC=$feparams{'final_dC'}
    fe_order = $feparams{'fe_order'}
    refinement_strategy   = $feparams{'refinement_strategy'}
    refinement_max_aspect_ratio = 3.0
    centers_max_diameter  = $feparams{'centers_max_diameter'}
    centers_near_diameter = $feparams{'centers_near_diameter'}
    end_refine = $feparams{'end_refine'}

    write_mesh = true
    write_solution = $feparams{'write_solution'}
    output_directory = "vacuum-${charge}-${boxH}"
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

