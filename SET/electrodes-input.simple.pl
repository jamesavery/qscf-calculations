#!/usr/bin/perl

# This file produces a set-up consisting of a rectangular unit cell
# with Dirichlet $V_L BVC on the (-x)-face, Dirichlet $V_R BVC on the
# (+x)-face, and homogeneous von Neumann BVCs on the remaining 4
# faces. Molecule is in the middle of the unit cell volume. No
# GMSH-mesh is used.
#
# This should give the same result as running electrodes-input.pl,
# which simulates the left/right-electrodes using fixed regions and a
# GMSH-generated mesh similar to the ./SET-mesh.pl-generated one.

do 'molecules.pm';

($moleculename, $charge,$Vsd,$final_dE) = @ARGV;

do 'config.pm';
do 'dimensions.pm';
do 'fe-config.pm';

# Left and right electrode get respectively half the source-drain voltage Vsd: V_L = -V/2, V_R = V/2
($V_L,$V_R,$V_G) = (-0.5*$Vsd*$eV,0.5*$Vsd*$eV,$Vg*$eV); 

($Hx, $Hy, $Hz) = ($vacuum_width/2,$vacuum_height/2,$slice_depth/2);

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
	unitcell = [ [ $vacuum_width 0 0 ] [ 0 $vacuum_height 0 ] [ 0 0 $slice_depth ] ]	
	unitcell:unit=bohr
)

surfaces<PhysicalSurfacesParam>:(
	{id description boundary_type boundary_value} = {
	    0 "Left electrode"      dirichlet $V_L
	    1 "Right electrode"     dirichlet $V_R
	}
)


calculator<LatticeFEMCalculator>: (
    lattice= \$:lattice
    basisset=\$:basissetDZP
    boundaryconditions = [ neumann neumann neumann ]
    meshcutoff:unit=hartree
    kpoints:monkhorstpack = [1 1 1]
    surfaces = \$:surfaces
    electrontemperature = $convergenceparams{'electrontemperature'}
    electrontemperature:unit = ev
    dielectric=\$:dielectric
    charge = $charge

    initial_refinement=$feparams{'initial_refinement'}
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

