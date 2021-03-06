#!/usr/bin/perl

# H + charge close to a metal.
# Method (a): Using a single Dirichlet boundary.

$eV = 0.0367493254;		# 1 eV in Hartrees
$nm = 18.897259886;		# 1 nm in Bohrs
$AA = $nm/10.0;

my ($charge,$dX) = @ARGV;

do 'fe-config.pm';

($boxW,$boxH,$boxD) = (1600*$AA,800*$AA,800*$AA);
$diW = $boxW/2.0;

($Hx,$Hy,$Hz) = ($diW+$dX,$boxH/2,$boxD/2);

$V_L = 0;

print << "END"
% box in Bohrs = [$boxW,$boxH,$boxD]
% diW in Bohrs = $diW
% dX  in Bohrs = $dX
% translate = [$Hx,$Hy,$Hz]
% V         = $V_L

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


volumes<PhysicalVolumesParam>:(
	{id description volume_type value} = {
	   1 "Left electrode"  fixed $V_L
	   2 "Vacuum"          dielectric 1
	}
)


surfaces<PhysicalSurfacesParam>:(
	{id description boundary_type boundary_value} = {
	    1 "Left electrode"      dirichlet $V_L
	    2 "Vacuum boundaries"   dirichlet 0
	}
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

calculator<LatticeFEMCalculator>: (	
    volumes  = \$:volumes
    surfaces = \$:surfaces    
    lattice= \$:lattice
    basisset=\$:basissetDZP
    boundaryconditions = [ neumann neumann neumann ]
    meshcutoff:unit=hartree
    kpoints:monkhorstpack = [1 1 1]
    electrontemperature = $convergenceparams{electrontemperature}
    electrontemperature:unit = ev

    charge = $charge
    mesh_file=mesh1.msh
    final_dE=$feparams{'final_dE'}
    final_dC=$feparams{'final_dC'}
    fe_order = $feparams{'fe_order'}
    refinement_strategy   = $feparams{'refinement_strategy'}
    centers_max_diameter  = $feparams{'centers_max_diameter'}
    centers_near_diameter = $feparams{'centers_near_diameter'}
    end_refine = $feparams{'end_refine'}

    write_mesh = $feparams{'write_mesh'}
    write_solution = $feparams{'write_solution'}
    output_directory = ${charge}-${dX}
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

