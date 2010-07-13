#!/bin/bash

molecule=$1

source config.sh;

directory=$molecule/vacuum-${final_dE}
mkdir -p $directory

ln -sf $PWD/bases $PWD/geometries $PWD/opv5parameters.in $PWD/$molecule/

for charge in -3.0 -2.0 -1.0 0.0 1.0 2.0 3.0 4.0 5.0; do
    ./vacuum-input.pl $molecule $charge > ${directory}/Exp1.${charge}.in 
done