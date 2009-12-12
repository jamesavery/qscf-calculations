#!/usr/bin/perl

# This file produces a set-up consisting of two volumes representing
# respectively vacuum and gate oxide. The gate oxide is represented by 
# a dielectric region. Molecule is $dist_y Bohrs above the oxide surface.

do 'molecules.pm';

# TODO: Vary thickness, dielectric constant and Vg
($moleculename, $charge,$Vg,$Dy,$H,$final_dE) = @ARGV;

do 'config.pm';
do 'dimensions.pm';
do 'fe-config.pm';

$Oxide_H      = $H*$AA;
$dist_y       = $Dy*$AA;
$translate_y  = $Oxide_H+$dist_y-$ymin;
$Hy           = $translate_y;

# Left and right electrode get respectively half the 
# source-drain voltage Vsd: V_L = -V/2, V_R = V/2
$Vg = $Vg*$eV;

($boxW,$boxH,$boxD) = ($Oxide_W,2*$Oxide_H,$Oxide_W);

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
	   1 "Vacuum"          dielectric 1
	   2 "Gate oxide"      dielectric $dielectric_constant
	}
)

surfaces<PhysicalSurfacesParam>:(
	{id description boundary_type boundary_value} = {
	    1 "Vacuum boundaries"     neumann 0
	    2 "Vacuum top"            dirichlet 0
	    3 "Oxide boundaries"      neumann 0
	    4 "Ground voltage"        dirichlet $Vg
	}
)


calculator<LatticeFEMCalculator>: (
    lattice= \$:lattice
    basisset=\$:basissetDZP
    boundaryconditions = [ dirichlet dirichlet dirichlet ]
    meshcutoff:unit=hartree
    kpoints:monkhorstpack = [1 1 1]
    surfaces = \$:surfaces
    volumes  = \$:volumes
    electrontemperature = $convergenceparams{'electrontemperature'}
    electrontemperature:unit = ev
    mesh_file = ${moleculename}-oxide-${Dy}-${H}.msh
    charge = $charge

    fe_order = $feparams{'fe_order'}
    refinement_strategy   = $feparams{'refinement_strategy'}
    centers_max_diameter  = $feparams{'centers_max_diameter'}
    centers_near_diameter = $feparams{'centers_near_diameter'}
    end_refine = $feparams{'end_refine'}

    initial_refinement=$feparams{'initial_refinement'}
    final_dE=${final_dE}

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

