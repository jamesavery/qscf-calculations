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


V=0
for charge in -2.0 -1.0 0.0 1.0 2.0
  do
  for ground in -4.0 -3.5 -3.0  -2.5 -2.0  -1.5 -1.0  -0.5 \
                 0.5 1.0  1.5 2.0 2.5 3.0  3.5 4.0
    do    
    ./SET-input.pl $molecule $charge $V $ground $final_dE > ${directory}/SET.${charge}:${ground}:${V}.in
  done
done
