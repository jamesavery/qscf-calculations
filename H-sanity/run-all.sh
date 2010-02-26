#!/bin/bash

source config.sh

experiments=(
	H-1:H H-2:Ha H-2:Hb H-3:e H-3:x H-3:q
)

    for exp in ${experiments[*]}; do
	exp=(`echo $exp | tr ':' ' '`)
	outdir=results/${final_dE}/
	outfile=${outdir}/${exp[0]}-${exp[1]}.m 

	mkdir -p ${outdir}

	echo "Running experiment ${exp[1]} in ${exp[0]}/${final_dE}/."

	./run-distributed.pl ${exp[1]} ${exp[0]}/${final_dE}
    done
