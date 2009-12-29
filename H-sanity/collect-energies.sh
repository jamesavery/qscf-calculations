#!/bin/bash

source config.sh

experiments=(
	H-1:H H-2:Ha H-3:e H-3:x H-3:q
)

    for exp in ${experiments[*]}; do
	exp=(`echo $exp | tr ':' ' '`)
	outdir=results/${final_dE}/
	outfile=${outdir}/${exp[0]}-${exp[1]}.m 

	mkdir -p ${outdir}

	echo "Generating ${outfile} from ${exp[0]}-${final_dE}/ ${exp[1]}.."

	../scripts/energies-math.pl ${exp[0]}/${final_dE}/ ${exp[1]} \
	    > ${outfile}
    done
