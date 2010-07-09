#!/bin/bash

source config.sh

molecules=(`../scripts/which-molecules.pl)
experiments=(
    groundzero:SET groundzero2:SET 
    oxide:Exp1 oxide:Exp2 oxide:Exp3 
    electrodes:Exp1 electrodes:Exp2 electrodes:Exp2b
    vacuum:Exp1 Vzero:SET-2 Vzero:SET
)

for m in ${molecules[*]}; do
    for exp in ${experiments[*]}; do
	exp=(`echo $exp | tr ':' ' '`)
	outdir=results/$m/${final_dE}/

	echo "Running all from $m/${exp[0]}-${final_dE}/ ${exp[1]}.."

	./run-distributed.pl ${exp[1]} $m/${exp[0]}-${final_dE}/
    done
done
