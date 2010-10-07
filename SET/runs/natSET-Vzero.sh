#!/bin/bash

molecule=$1

source config.sh;

directory=$molecule/natVzero-${final_dE}
mkdir -p $directory

./natSET-mesh.pl $molecule > $directory/${molecule}-natSET.geo
pushd $directory
gmsh -3 -algo front3d ${molecule}-natSET.geo
popd
ln -sf $PWD/bases $PWD/geometries $PWD/opv5parameters.in $PWD/$molecule/


Vsd=0
for charge in -5.0 -4.0 -3.0 -2.0 -1.0 0.0 1.0 2.0 3.0 4.0 5.0
  do
  for Vg in -4.0 0.0 1.0 4.0
    do    
    ./natSET-input.pl $molecule $charge $Vg $Vsd > ${directory}/natSET.${charge}:${Vg}:${Vsd}.in
  done
done

Vsd=1
for charge in -5.0 -4.0 -3.0 -2.0 -1.0 0.0 1.0 2.0 3.0 4.0 5.0
  do
  for Vg in -4.0 0.0 1.0 4.0
    do    
    ./natSET-input.pl $molecule $charge $Vg $Vsd > ${directory}/natSET-2.${charge}:${Vg}:${Vsd}.in
  done
done

