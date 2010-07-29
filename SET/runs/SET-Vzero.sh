#!/bin/bash

molecule=$1

source config.sh;

directory=$molecule/Vzero-${final_dE}
mkdir -p $directory

./SET-mesh.pl $molecule > $directory/${molecule}-set.geo
pushd $directory
gmsh -3 -algo front3d ${molecule}-set.geo
popd
ln -sf $PWD/bases $PWD/geometries $PWD/opv5parameters.in $PWD/$molecule/


Vsd=0
for charge in -3.0 -2.0 -1.0 0.0 1.0 2.0 3.0 4.0 5.0
  do
  for Vg in -8.0 -4.0 -1.0  0.0 1.0 4.0 8.0
    do    
    ./SET-input.pl $molecule $charge $Vg $Vsd > ${directory}/SET.${charge}:${Vg}:${Vsd}.in
  done
done

Vsd=1
for charge in -3.0 -2.0 -1.0 0.0 1.0 2.0 3.0 4.0 5.0
  do
  for Vg in -8.0 -4.0 -1.0  0.0 1.0 4.0 8.0
    do    
    ./SET-input.pl $molecule $charge $Vg $Vsd > ${directory}/SET-2.${charge}:${Vg}:${Vsd}.in
  done
done

