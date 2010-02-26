
molecule=OPV5-tertbutyl-vnl

include config.sh

dE=${final_dE}

%-inputs: check-%.sh SET-input.pl SET-mesh.pl
	echo "Making input files..."
	./$< ${molecule}

%-output: energies-math.pl energies-gpl.pl
	job=`basename $@ \-output` && dir="$${job}-${dE}" && \
	(./energies-math.pl $${dir} > $${dir}/output.m)  && \
	(./energies-gpl.pl $${dir} > $${dir}/output.gpl)

large: large-inputs
	./run-distributed.pl ${config} SET ${molecule}/large-${dE}

groundzero: groundzero-inputs
	./run-distributed.pl ${config} SET ${molecule}/groundzero-${dE}

Vzero: Vzero-inputs
	./run-distributed.pl ${config} SET ${molecule}/Vzero-${dE}

outputs: H1-output H2-output H3e-output H3q-output H3x-output
	mkdir -p outputs-${dE}
	for d in $^; do \
		basename=`basename $$d -output`; \
		dirname=$${basename}-${dE}; \
		cp $${dirname}/output.m   outputs-${dE}/$${basename}.m; \
		cp $${dirname}/output.gpl outputs-${dE}/$${basename}.gpl; \
	done 
	tar czf outputs-${dE}.tar.gz outputs-${dE}
	scp outputs-${dE}.tar.gz tyr:outputs/

clean:
	find . -\( -name "*~" -or -name "#*#" -or -name ".#*" -\) -exec rm {} \;

distclean: clean
	find . -\( -name "*.err" -or -name "*.cpt" -\) -exec rm {} \; 

reallyclean: distclean
	rm -rf H1-${dE} H2-${dE} H3?-${dE} H4?-${dE} H5-${dE}
