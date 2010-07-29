#!/bin/bash

molecule=$1

source config.sh;

directory=$molecule/large-${final_dE}
mkdir -p $directory

./SET-mesh.pl $molecule > $directory/${molecule}-set.geo
pushd $directory
gmsh -3 -algo front3d ${molecule}-set.geo
popd
ln -sf $PWD/bases $PWD/geometries $PWD/opv5parameters.in $molecule/


for charge in -3.0 -2.0 -1.0 0.0 1.0 2.0 3.0
  do
  for Vg in -6.0 -2.0 0.0 2.0 6.0
    do    
    for Vsd in -5.0 -4.0 -3.0 -2.0 -1.0 0.0 \
              5.0  4.0  3.0  2.0  1.0 
      do
      ./SET-input.pl $molecule $charge $Vg $Vsd > $directory/SET.${charge}:${Vg}:${Vsd}.in
    done
  done
done
