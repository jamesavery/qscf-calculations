#!/bin/bash

source config.sh;

# TODO: dX=8.0 afsloerer bug i centers_plus_density refinement implementationen.

mkdir -p H-2/${final_dE}
ln -sf $PWD/meshes/mesh1.msh H-2/${final_dE}

# Method (a)
for dX in 2.0 3.0 4.0 5.0 6.0 6.25 6.5 6.75\
          7.0 7.5 8.1 9.0 10.0 13.0 15.0 17.0 20.0 25.0 30.0
do 
    for charge in -2.0 -1.5 -1.0 -0.5 -0.2 0.0 0.2 0.5 0.9 0.95
    do
	./H-2a.pl $charge $dX > H-2/${final_dE}/Ha.${charge}:${dX}.in
	./H-2b.pl $charge $dX > H-2/${final_dE}/Hb.${charge}:${dX}.in
    done
done

# TODO: Method (b): Mesh and fixed region.
