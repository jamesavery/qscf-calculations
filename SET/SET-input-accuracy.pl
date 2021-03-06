#!/usr/bin/perl

do 'molecules.pm';

($moleculename, $charge,$Vsd,$Vg, $dE, $dC, $refinement_strategy) = @ARGV;

if(!defined($refinement_strategy)){
 $refinement_strategy = "centers_plus_density";
}

if(!defined($dC)){
 $dC = 1e6; # Random enormous number.
}
do 'config.pm';
do 'dimensions.pm';
do 'fe-config.pm';

# Left and right electrode get respectively half the source-drain voltage Vsd: V_L = -V/2, V_R = V/2
($V_L,$V_R,$V_G) = (-0.5*$Vsd*$eV,0.5*$Vsd*$eV,$Vg*$eV); 


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
	   1 "Gate oxide"      dielectric $dielectric_constant
	   2 "Vacuum"          dielectric 1
	   3 "Left electrode"  fixed $V_L
	   4 "Right electrode" fixed $V_R
	}
)


surfaces<PhysicalSurfacesParam>:(
	{id description boundary_type boundary_value} = {
	    1 "Vacuum boundaries"   neumann 0
	    2 "Ground voltage"      dirichlet $V_G
	    3 "Left electrode"      dirichlet $V_L
	    4 "Right electrode"     dirichlet $V_R
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
    mesh_file = ${moleculename}-set.msh
    gate=\$:gate
    charge = $charge

    final_dE=$dE
    final_dC=$dC
    fe_order = $feparams{'fe_order'}
    refinement_strategy   = $refinement_strategy
    centers_max_diameter  = $feparams{'centers_max_diameter'}
    centers_near_diameter = $feparams{'centers_near_diameter'}
    end_refine = $feparams{'end_refine'}

    write_mesh = $feparams{'write_mesh'}
    write_solution = $feparams{'write_solution'}
    output_directory = "SET-${charge}-${Vg}-${Vsd}"
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

