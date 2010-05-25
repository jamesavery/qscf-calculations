#!/bin/bash

molecule=$1

source config.sh;

directory=$molecule/SET-accuracy
mkdir -p $directory

./SET-mesh.pl $molecule > $directory/${molecule}-set.geo
pushd $directory
gmsh -3 -algo front3d ${molecule}-set.geo
popd
ln -sf $PWD/bases $PWD/geometries $PWD/opv5parameters.in $PWD/$molecule/


V=2.0
for dE in 0.015 0.008 0.004 0.001 0.0005 0.00025; do
for charge in -2.0 -1.0 0.0 1.0 2.0
  do
  for ground in -6.0 -3.0 -1.0 0.0 1.0  3.0 6.0
    do    
    ./SET-input-accuracy.pl $molecule $charge $V $ground $dE > ${directory}/SET-2.${charge}:${ground}:${V}:${dE}.in
  done
done
done
