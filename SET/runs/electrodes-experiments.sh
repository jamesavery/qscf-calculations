#!/bin/bash
# All the experiments in this file use the setup of the molecule
# sitting between two electrodes at distance Dx Aangstrom from each
# electrode to nearest nucleus.
# There is no oxide.

molecule=$1

source config.sh;

directory=$molecule/electrodes-${final_dE}
mkdir -p $directory

ln -sf $PWD/bases $PWD/geometries $PWD/opv5parameters.in $PWD/$molecule/

generate_mesh(){
    Dy=$1
    H=$2
    ./electrodes-mesh.pl $molecule $Dy $H > $directory/${molecule}-electrodes-$Dy-$H.geo
    pushd $directory
    gmsh -algo front3d -3 ${molecule}-electrodes-$Dy-$H.geo
    popd
}


# Exp. 1
# We vary the distance Dx from the nearest nucleus to each of the electrodes,
# as well as the voltage drop over the electrodes.
H=50
for Dx in 0.7 1 2 3 5 10; do
    generate_mesh $Dx $H
    for Vsd in 0 0.05 0.10 0.15 0.20 0.25 0.30 0.40 0.50 0.75 1.0
      do
      for charge in -1.0 0.0 1.0 
	do
	./electrodes-input.pl $molecule $charge $Vsd $Dx $H $final_dE > ${directory}/Exp1.${charge}:${Vsd}:${Dx}.in
      done
    done
done


# Exp. 2: As SET-groundzero, but without dielectric.
H=50
Dx=1
generate_mesh $Dx $H
for charge in -2.0 -1.0 0.0 1.0 2.0; do
    for Vsd in  -2.0 -1.5 -1.0 -0.5 0.0 0.5 1.0 1.5 2.0
      do
      ./electrodes-input.pl $molecule $charge $Vsd $Dx $H $final_dE > ${directory}/Exp2.${charge}:${Vsd}:${Dx}.in
    done
done