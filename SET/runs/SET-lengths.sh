#!/bin/bash

molecule=$1

source config.sh;

directory=$molecule/SET-lengths-${final_dE}
mkdir -p $directory

ln -sf $PWD/bases $PWD/geometries $PWD/opv5parameters.in $PWD/$molecule/

generate_mesh(){
    Dx=$1
    Dy=$2
    H=$3
    ./SET-mesh-lengths.pl $molecule $Dx $Dy $H > $directory/${molecule}-oxide-$Dx-$Dy-$H.geo
    pushd $directory
    gmsh -algo front3d -3 ${molecule}-oxide-$Dy-$H.geo
    popd
}


# Exp. 1
# Varies oxide lengths H while keeping the distance Dy fixed at 0.1nm.
# We want to obtain U, Delta, E_C and possibly \alpha as a function of H
Dy=1

for H in 10 20 30 40 50 60 70 80 90 100; do
    generate_mesh $Dy $H
    for Vg in 0.0 2.0 4.0; do
	for charge in -1.0 0.0 1.0 
	  do
	  ./SET-input-lengths.pl $molecule $charge $Vg $Dy $H > ${directory}/Exp1.${charge}:${Vg}:${H}.in
	done
    done
done


# Exp. 2
# We keep the oxide lengths fixed at 5nm and vary the distance Dy from the
# oxide to neares nucleus of the molecule.
# We want to obtain U, Delta, E_C and possibly \alpha as a function of H
H=50
for Dy in 0.5 1 2 3 5 10; do
    generate_mesh $Dy $H
    for Vg in 0 2.0 4.0; do
	for charge in -1.0 0.0 1.0; do
	    ./SET-input-lengths.pl $molecule $charge $Vg $Dy $H > ${directory}/Exp2.${charge}:${Vg}:${Dy}.in
	done
    done
done
