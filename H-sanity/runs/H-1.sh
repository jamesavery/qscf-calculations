#!/bin/bash

source config.sh;

mkdir -p H1-${final_dE}
for charge in -2.0 -1.9 -1.8 -1.7 -1.6 -1.5 -1.4 -1.3 -1.2 -1.1 -1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.95 0.97
do
    ./H-1.pl $charge $initial $final_dE > H1-${final_dE}/H.${charge}.in
done

