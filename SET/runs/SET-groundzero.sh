#!/bin/bash

molecule=$1

source config.sh;

directory=${molecule}/groundzero-${final_dE}
mkdir -p $directory

./SET-mesh.pl $molecule > $directory/${molecule}-set.geo
pushd $directory 
gmsh -3 -algo front3d ${molecule}-set.geo
popd
ln -sf $PWD/bases $PWD/geometries $PWD/opv5parameters.in $molecule/

ground=0.0
for charge in -2.0 -1.0 0.0 1.0 2.0
  do
  for V in -0.5 -0.45 -0.4 -0.35 -0.3 -0.25 -0.2 -0.15 -0.1 -0.05 \
      0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5
    do
    ./SET-input.pl ${molecule} $charge $V $ground > $directory/SET.${charge}:${ground}:${V}.in
  done
done

