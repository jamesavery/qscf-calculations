#!/bin/bash

source ./config.sh;

mkdir -p H-3/${final_dE}
./mesh1.pl > meshes/mesh1.geo
cd meshes 
gmsh -3 -algo front3d mesh1.geo
cd ..
ln -sf ${PWD}/meshes/mesh1.msh H-3/${final_dE}/

for dielectric_constant in 1.0 2.0 5.0 8.0 10.0 20.0 40.0 80.0 200.0 800.0 1600.0 3200.0
do
    for dX in 6.5 10.0 20.0 30.0
    do 
	for charge in -1.0 -0.5 0.0 0.5 
	do
	    ./H-3.pl $charge $dX $dielectric_constant \
		> H-3/${final_dE}/e.${charge}:${dX}:${dielectric_constant}.in
	done
    done
done


for dielectric_constant in 1.0 10.0 10000.0
do
    for dX in 6.5 7.0 7.5 8.0 8.5 9.0 9.5 10.0 10.5 11.0 12.0 13.0 15.0 17.0 20.0 26.0 30.0
    do 
	for charge in -1.0 0.0 0.5
	do
	    ./H-3.pl $charge $dX $dielectric_constant \
		> H-3/${final_dE}/x.${charge}:${dX}:${dielectric_constant}.in
	done
    done
done


for dielectric_constant in 1.0 10.0 10000.0
do
    for dX in 6.5 10.0 15.0 30.0
    do 
	for charge in -2.0 -1.5 -1.25 -1.0 -0.9 -0.8 -0.7 -0.5 -0.3 -0.2 0.0 0.2 0.5 0.4 0.8 0.9
	do
	    ./H-3.pl $charge $dX $dielectric_constant \
		> H-3/${final_dE}/q.${charge}:${dX}:${dielectric_constant}.in
	done
    done
done

