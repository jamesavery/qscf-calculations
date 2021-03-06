#!/bin/bash

source config.sh

molecules=(`../scripts/which-molecules.pl`)
experiments=(
    groundzero:SET groundzero2:SET 
    oxide:Exp1 oxide:Exp2 oxide:Exp3 
    electrodes:Exp1 electrodes:Exp2 electrodes:Exp2b
    vacuum:Exp1 Vzero:SET-2 Vzero:SET
    SET2-Vzero:SET SET2-Vzero:SET-2
    large:SET
)

for m in ${molecules[*]}; do
    for exp in ${experiments[*]}; do
	exp=(`echo $exp | tr ':' ' '`)
	outdir=results/$m/${final_dE}/
	outfile=${outdir}/${exp[0]}-${exp[1]}.m 

	mkdir -p ${outdir}
	echo "(* Configuration used to calculate this file: " > ${outfile}
	cat config.pm >> ${outfile}
	echo "*)\n" >> ${outfile}

	echo "Generating ${outfile} from $m/${exp[0]}-${final_dE}/ ${exp[1]}.."

	../scripts/energies-math.pl $m/${exp[0]}-${final_dE}/ ${exp[1]} \
	    > ${outfile}
    done
done
