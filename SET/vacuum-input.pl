#!/usr/bin/perl

do 'molecules.pm';

($moleculename,$charge) = @ARGV;

do 'config.pm';
do 'fe-config.pm';

%cm = $molecule{$moleculename}{'center of mass'};

($boxW,$boxH,$boxD) = ($vacuum_box_size,$vacuum_box_size,$vacuum_box_size);
# Center of mass is at center of volume
($Hx,$Hy,$Hz) = ($boxW/2-$cm{x},$boxH/2-$cm{y},$boxD/2-$cm{z}); 

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


calculator<LatticeFEMCalculator>: (
    lattice= \$:lattice
    basisset=\$:basissetDZP
    boundaryconditions = [ dirichlet dirichlet dirichlet ]
    meshcutoff:unit=hartree
    kpoints:monkhorstpack = [1 1 1]
    electrontemperature = $convergenceparams{electrontemperature}
    electrontemperature:unit = ev

    charge = $charge
    initial_refinement=$feparams{'initial_refinement'}
    final_dE=$feparams{'final_dE'}
    final_dC=$feparams{'final_dC'}
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
