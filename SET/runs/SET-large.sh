#!/bin/bash

molecule=$1

source config.sh;

directory=$molecule/large-${final_dE}
mkdir -p $directory

./SET-mesh.pl $molecule > $directory/${molecule}-set.geo
pushd $directory
gmsh -3 ${molecule}-set.geo
popd
ln -sf $PWD/bases $PWD/geometries $PWD/opv5parameters.in $molecule/


for charge in -2.0 -1.0 0.0 1.0 2.0
  do
  for ground in -4.0 -3.5 -3.0  -2.5 -2.0  -1.5 -1.0  -0.5 -0.25 0.125 0.0 0.125 0.25\
                 0.5 1.0  1.5 2.0 2.5 3.0  3.5 4.0
    do    
    for V in -0.5 -0.45 -0.4 -0.35 -0.3 -0.25 -0.2 -0.15 -0.1 -0.05 \
	0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5
      do
      ./SET-input.pl $molecule $charge $V $ground $final_dE > $directory/SET.${charge}:${ground}:${V}.in
    done
  done
done
