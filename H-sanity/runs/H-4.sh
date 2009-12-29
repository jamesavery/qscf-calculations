#!/bin/bash

source ./config.sh;

mkdir -p H4a-${final_dE}
mkdir -p H4b-${final_dE}

for bias in -1.0 -0.5 -0.25 -0.125 -0.075 -0.0375 0.0 0.0375 0.075 0.125 0.25 0.5 1.0
do
    for dX in 10.0 20.0 30.0
    do 
	for charge in -1.0 -0.5 0.0 0.5 
	do
	    ./H-4a.pl $charge $dX $bias $final_dE \
		> H4a-${final_dE}/H.${charge}:${dX}:${bias}.in
	done
    done
done

