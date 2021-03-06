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
    ./SET-mesh-lengths.pl $molecule $Dx $Dy $H > $directory/${molecule}-set-$Dx-$Dy-$H.geo
    pushd $directory
    gmsh -algo front3d -3 ${molecule}-set-$Dx-$Dy-$H.geo
    popd
}


# Exp. 1-3 all have Vsd=0
Vsd=0.0

# Exp. 1
# Varies oxide lengths H while keeping the distance Dy fixed at 0.1nm.
# We want to obtain U, Delta, E_C and possibly \alpha as a function of H
Dy=1
Dx=1
for H in 10 20 30 40 50 60 70 80 90 100; do
    generate_mesh $Dx $Dy $H
    for Vg in 0.0 2.0 4.0; do
	for charge in -1.0 0.0 1.0 
	  do
	  ./SET-input-lengths.pl $molecule $charge $Vg $Vsd $Dx $Dy $H > ${directory}/Exp1.${charge}:${Vg}:${H}.in
	done
    done
done


# Exp. 2
# We keep the oxide lengths fixed at 5nm and vary the distance Dy from the
# oxide to neares nucleus of the molecule.
# We want to obtain U, Delta, E_C and possibly \alpha as a function of H
H=50
Dx=1
for Dy in 0.0 0.125 0.25 0.5 0.75 1 2 3 5; do
    generate_mesh $Dx $Dy $H
    for Vg in 0.0 2.0 4.0; do
	for charge in -1.0 0.0 1.0; do
	    ./SET-input-lengths.pl $molecule $charge $Vg $Vsd $Dx $Dy $H > ${directory}/Exp2.${charge}:${Vg}:${Dy}.in
	done
    done
done


# Exp. 3.
# Like electrodes-experiments Exp. 1
# We vary the distance Dx from the nearest nucleus to each of the electrodes,
# as well as the gate voltage.
H=50.0
Dy=1.0
for Dx in 0.0 0.125 0.25 0.5 0.75 1.0 1.5 2 3 5; do
    generate_mesh $Dx $Dy $H
    for Vg in 0.0 2.0 4.0
      do
      for charge in -1.0 0.0 1.0 
	do
	./SET-input-lengths.pl $molecule $charge $Vg $Vsd $Dx $Dy $H > ${directory}/Exp3.${charge}:${Vg}:${Dx}.in
      done
    done
done


# Exp. 4.
# Like electrodes-experiments Exp. 1
# We vary the distance Dx from the nearest nucleus to each of the electrodes,
# as well as the voltage drop over the electrodes.
H=50.0
Dy=1.0
Vg=0.0
for Dx in 0.5 1 2 3 5 10; do
    generate_mesh $Dx $Dy $H
    for Vsd in 0.0 0.10 0.30 0.40 0.50 0.75 1.0
      do
      for charge in -1.0 0.0 1.0 
	do
	./SET-input-lengths.pl $molecule $charge $Vg $Vsd $Dx $Dy $H > ${directory}/Exp4.${charge}:${Vsd}:${Dx}.in
      done
    done
done

