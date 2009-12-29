# This file defines parameters for the numerical calculations.

# Parameters for SCF-iteration
%convergenceparams = (
    tolerance => 3.e-4,
    maxiterations => 25,
    electrontemperature => 0.01
);

# Parameters for FEM-code
%feparams = (
    'fe_order' => 1,
    'write_mesh' => 0,		
    'write_solution' => "none",
    'refinement_strategy' => 'centers_plus_density',
    'centers_max_diameter'=>5,
    'centers_near_diameter'=>7,	# Any cell within this distance must
				# have diameter centers_max_diameter
				# or smaller.

    'end_refine' => 2.5,        # How much should the mesh be refined
				# when doing final total-energy
				# calculation?

    'initial_refinement' => 3,	# For unit-cell meshes, what should the
                                # initial refinement be? Doesn't apply 
	                        # when loading meshes.
    'final_dE' => `cut -f 2 -d = config.sh`
 );
 

