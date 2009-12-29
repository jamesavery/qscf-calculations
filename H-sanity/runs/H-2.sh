#!/bin/bash

source config.sh;

# TODO: dX=8.0 afsloerer bug i centers_plus_density refinement implementationen.

mkdir -p H2-${final_dE}
for dX in 6.0 6.25 6.5 6.75 7.0 7.5 8.1 9.0 10.0 13.0 15.0 17.0 20.0 25.0 30.0
do 
    for charge in -1.0 -0.5 -0.2 0.0 0.2 0.5 0.9
    do
	./H-2.pl $charge $dX $initial $final_dE > H2-${final_dE}/H.${charge}:${dX}.in
    done
done

