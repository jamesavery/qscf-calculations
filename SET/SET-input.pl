#!/usr/bin/perl

do 'molecules.pm';

($moleculename, $charge,$Vsd,$Vg,$final_dE) = @ARGV;

do 'config.pm';
do 'dimensions.pm';

# Left and right electrode get respectively half the source-drain voltage Vsd: V_L = -V/2, V_R = V/2
($V_L,$V_R,$V_G) = (-0.5*$Vsd*$eV,0.5*$Vsd*$eV,$Vg*$eV); 

# Global parameters
$tolerance  = 3.e-4;
$maxiterations = 25;
$feoptions = 
    "fe_order=1\n".
    "\tfinal_dE = ${final_dE}\n".
    "\tnew_totalenergy=1\n".
    "\tno_grid=1\n".
    "\twrite_mesh=1\n".
    "\tend_refine=2.5\n".
    "\tcenters_max_diameter=5\n".
    "\tcenters_near_diameter=7\n".
    "\trefinement_strategy=centers_plus_density\n";


&Hinputfile("LatticeFEMCalculator",$feoptions,$dist);

sub Hinputfile {
    my ($Calculator,$FEoptions,$dist) = @_;

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

dielectric<DielectricParam>:(
	geometry:unit = bohr
% Gate oxide
      {constant shape shape:parameters  geometry } = {
	$dielectric_constant  box   [ $Oxide_w $Oxide_h $Oxide_d ] [ $Oxide_x $Oxide_y $Oxide_z ] 
      }
)


volumes<PhysicalVolumesParam>:(
	{id description volume_type value} = {
	   1 "Aluminium oxide" dielectric $dielectric_constant
	   2 "Vacuum"          dielectric 1
	   3 "Left electrode"  fixed $V_L
	   4 "Right electrode" fixed $V_R
	}
)


surfaces<PhysicalSurfacesParam>:(
	{id description boundary_type boundary_value} = {
%	    0 "Box boundaries (only for box mesh)" dirichlet 0
	    1 "Vacuum boundaries"   neumann 0
	    2 "Ground voltage"      dirichlet $V_G
	    3 "Left electrode"      dirichlet $V_L
	    4 "Right electrode"     dirichlet $V_R
	}
)


calculator<$Calculator>: (
	lattice= \$:lattice
	basisset=\$:basissetDZP
	boundaryconditions = [ neumann neumann neumann ]
	meshcutoff:unit=hartree
        kpoints:monkhorstpack = [1 1 1]
        surfaces = \$:surfaces
	volumes  = \$:volumes
	electrontemperature = 0.01
	electrontemperature:unit = ev
        mesh_file = ${moleculename}-set.msh
	gate=\$:gate
	dielectric=\$:dielectric
        charge = $charge
        $FEoptions
)

qscf<ScfParam>: (
	calculator=\$:calculator
	diis:n = 8
	diis:start = 1
	diis:dampingfactor = 0.8
	precondition= false
	tolerance=$tolerance
	variable=hamiltonian
	maxiterations=$maxiterations
	verbose=10
)

END

};
