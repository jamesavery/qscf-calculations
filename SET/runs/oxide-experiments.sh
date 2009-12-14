#!/bin/bash

molecule=$1

source config.sh;

directory=$molecule/oxide-${final_dE}
mkdir -p $directory

ln -sf $PWD/bases $PWD/geometries $PWD/opv5parameters.in $PWD/$molecule/

generate_mesh(){
    Dy=$1
    H=$2
    ./oxide-mesh.pl $molecule $Dy $H > $directory/${molecule}-oxide-$Dy-$H.geo
    pushd $directory
    gmsh -algo front3d -3 ${molecule}-oxide-$Dy-$H.geo
    popd
}


# Exp. 1
Dy=1

for H in 10 20 30 40 50 60 70 80 90 100; do
    generate_mesh $Dy $H
    for Vg in 0 1.0 2.0 4.0; do
	for charge in -1.0 0.0 1.0 
	  do
	  ./oxide-input.pl $molecule $charge $Vg $Dy $H $final_dE > ${directory}/Exp1.${charge}:${Vg}:${H}.in
	done
    done
done

# Exp. 2
H=50
for Dy in 0.5 1 2 3 5 10; do
    generate_mesh $Dy $H
    for Vg in 0 1.0 2.0 4.0; do
	for charge in -1.0 0.0 1.0; do
	    ./oxide-input.pl $molecule $charge $Vg $Dy $H $final_dE > ${directory}/Exp2.${charge}:${Vg}:${Dy}.in
	done
    done
done

# Exp. 3: As SET-Vzero, but without electrodes.
H=50
Dy=1
for charge in -2.0 -1.0 0.0 1.0 2.0; do
    for Vg in -4.0 -3.5 -3.0  -2.5 -2.0  -1.5 -1.0  -0.5 \
	0.5 1.0  1.5 2.0 2.5 3.0  3.5 4.0
      do
      ./oxide-input.pl $molecule $charge $Vg $Dy $H $final_dE > ${directory}/Exp3.${charge}:${Vg}.in
    done
done


