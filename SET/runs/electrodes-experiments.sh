#!/bin/bash

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
H=50
for Dx in 1 2 3 5 10; do
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
    for Vsd in -0.5 -0.45 -0.4 -0.35 -0.3 -0.25 -0.2 -0.15 -0.1 -0.05 \
	0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5
      do
      ./electrodes-input.pl $molecule $charge $Vsd $Dx $H $final_dE > ${directory}/Exp2.${charge}:${Vsd}:${Dx}.in
    done
done

# Exp. 2b: As SET-groundzero2, but without dielectric.
H=50
Dx=1
generate_mesh $Dx $H
for charge in -2.0 -1.0 0.0 1.0 2.0; do
   for Vsd in -2.0 -1.5 -1.0 -0.5 0.0 0.5 1.0 1.5 2.0; do
      ./electrodes-input.pl $molecule $charge $Vsd $Dx $H $final_dE > ${directory}/Exp2b.${charge}:${Vsd}:${Dx}.in
    done
done

