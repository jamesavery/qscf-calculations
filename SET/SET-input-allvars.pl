#!/usr/bin/perl

do 'molecules.pm';

($moleculename, $charge,$Vg,$Vsd,$dist_x,$dist_y,$oxideH,$boxW,$boxH,$boxD,$dielectric_constant,$meshsuffix,$outputdir,$feconfig) = @ARGV;

print STDERR "SET-input-allvars ($moleculename, $charge,$Vg,$Vsd,$dist_x,$dist_y,$oxideH,$boxW,$boxH,$boxD,$dielectric_constant,$meshsuffix,$outputdir,$feconfig)\n";

if(!defined($feconfig)){ $feconfig = "fe-config"; }
do 'dimensions-allvars.pm';
do "${feconfig}.pm";
print STDERR "~>        ($dist_x,$dist_y,$oxideH,$boxW,$boxH,$boxD) Bohrs\n";
print STDERR "translate ($translate_x,$translate_y,$translate_z) Bohrs\n";

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
        translate_basis = [$translate_x $translate_y $translate_z]
	unitcell = [ [ $boxW 0 0 ] [ 0 $boxH 0 ] [ 0 0 $boxD ] ]	
	unitcell:unit=bohr
)

volumes<PhysicalVolumesParam>:(
	{id description volume_type value} = {
	   1 "Left electrode"  fixed $V_L
	   2 "Vacuum"          dielectric 1
	   3 "Right electrode" fixed $V_R
	   4 "Gate oxide"      dielectric $dielectric_constant

	}
)


surfaces<PhysicalSurfacesParam>:(
	{id description boundary_type boundary_value} = {
	    5 "Open boundaries"   neumann 0
	    6 "Left electrode"    dirichlet $V_L
	    7 "Right electrode"   dirichlet $V_R
	    8 "Ground voltage"    dirichlet $V_G
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
    electrontemperature:unit = eV
    mesh_file = "${moleculename}-${meshsuffix}.msh"
    gate=\$:gate
    charge = $charge

    final_dE=$feparams{'final_dE'}
    final_dC=$feparams{'final_dC'}
    fe_order = $feparams{'fe_order'}
    refinement_strategy   = $feparams{'refinement_strategy'}
    centers_max_diameter  = $feparams{'centers_max_diameter'}
    centers_near_diameter = $feparams{'centers_near_diameter'}
    end_refine = $feparams{'end_refine'}

    write_mesh = $feparams{'write_mesh'}
    write_solution = $feparams{'write_solution'}
    output_directory = "${outputdir}"
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

